function [ dat ] = plotERSP(data , varargin )
%UNTITLED �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ

dat = data;
opt = opt_CellToStruct(varargin{:});

sampleFrequency=dat.fs;
%% mem model order?
modelOrder = 18+round(sampleFrequency/100);
opt.lowPassCutoff=(sampleFrequency/2)-10;
% highPassCutoff=-1;
% freqBinWidth=2;
%  ���� ©���� ����
opt.trend=1;

params = [modelOrder, opt.highPassCutoff+opt.freqBinWidth/2, opt.lowPassCutoff-opt.freqBinWidth/2, opt.freqBinWidth,round(opt.freqBinWidth/.2), opt.trend, sampleFrequency];
memparms = params;

[nD nTr nCh]=size(dat.x)
% spectralStep=200;
% spectralSize=200;
% datalength=round(nD/spectral_stepping)-1

memparms(8) = opt.spectralStep;
memparms(9) = (opt.spectralSize/opt.spectralStep);% �޺κ� ©���� ����
%% Here is last update
idx=find(dat.y_dec==1);
idx2 = find(SMT.y_dec==2);
C1=prep_selectTrials(SMT,idx);
C2=prep_selectTrials(SMT,idx2);



for i=1:nTr/26
    dat=C1.x(:,i,:);
    dat=squeeze(dat);
    [trialspectrum, freq_bins] = mem( dat, memparms );
    tm1=mean(trialspectrum, 3);
    dat_c1(:,:,i)=tm1;
end

mean_c1=mean(dat_c1,3);
xData=freq_bins


dispmin=min(min(mean_c1));
dispmax=max(max(mean_c1));
num_channels=size(mean_c1, 2);
data2plot=mean_c1;
data2plot=cat(2, data2plot, zeros(size(data2plot, 1), 1));
data2plot=cat(1, data2plot, zeros(1, size(data2plot, 2)));

xData(end+1) = xData(end) + diff(xData(end-1:end));
surf(xData(4:end), [1:num_channels + 1], data2plot(4:end,:)');
view(2);
colormap jet;
colorbar;



%% class 2 
for i=1:nTr/2
    dat=C2.x(:,i,:);
    dat=squeeze(dat);
    [trialspectrum, freq_bins] = mem( dat, memparms );
    tm1=mean(trialspectrum, 3);
    dat_c1(:,:,i)=tm1;
end

mean_c1=mean(dat_c1,3);
xData=freq_bins


dispmin=min(min(mean_c1));
dispmax=max(max(mean_c1));
num_channels=size(mean_c1, 2);
data2plot=mean_c1;
data2plot=cat(2, data2plot, zeros(size(data2plot, 1), 1));
data2plot=cat(1, data2plot, zeros(1, size(data2plot, 2)));

xData(end+1) = xData(end) + diff(xData(end-1:end));
figure;
surf(xData(4:end), [1:num_channels + 1], data2plot(4:end,:)');
view(2);
colormap jet;
colorbar;

end
