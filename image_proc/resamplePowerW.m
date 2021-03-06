function wout=resamplePowerW(w,nx,ny,resampleFactor,pow,makeImage,gaussFiltering)
% Resamples (by resampleFactor) resutlts W of NMF (res.w), makes their power (by pow) and normalizes
% them to sum to 1. If pow is a vector (1 X ncomp) then i'th component is
% raised to the pow(i). (allows different components to be raised to
% different powers.)
% makeImage = 1 results in wout being stack of images (nx X ny X ncomp)
% rather then a nx*ny X ncomp matrix (default)
% gaussFiltering value of hte sigma (in non resampled iamge) used for
% gaussFiltering of hte results. If set to 0, no gauss filters. Default
% gaussFiltering = 1; 
%
%
% wout=resamplePowerW(w,nx,ny,resampleFactor,pow,makeImage,gaussFiltering)
%
% example: 
% wout=resamplePowerW(res.w, peval.nx, peval.ny, 4,2,1);
% figure; imstiled(wout)
if size(pow,1)<size(pow,2) %must be a column vector
    pow=pow';
end
if ~exist('makeImage','var')
    makeImage = 0; 
end
if ~exist('gaussFiltering','var')
    gaussFiltering = 1; 
end
ncomp=size(w,2); 
% wr=resampleImageStack(reshape(w, nx, ny, ncomp),resampleFactor).^pow;
% wout=normcSum(reshape(wr,resampleFactor^2*nx*ny,ncomp)); % normalized to sum to 1
wr=resampleImageStack(reshape(w, nx, ny, ncomp),resampleFactor);
if gaussFiltering
    % gauss - filtering:
    fprintf('Filtering with gaussian to reduce peaks from noise.\n')
    s=resampleFactor*gaussFiltering;
    wr=reshape(double(gaussf(reshape(wr,resampleFactor*nx,resampleFactor*ny,ncomp),[s s 0])),resampleFactor*nx,resampleFactor*ny,ncomp);
end
wout=normcSum(bsxfun(@power,reshape(wr,resampleFactor^2*nx*ny,ncomp),pow')); % normalized to sum to 1
if makeImage
    wout = reshape(wout, resampleFactor*nx, resampleFactor*ny, ncomp); 
end