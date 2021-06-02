clc;
clear;

yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim �ļ�·��
yuan_data_name = '107to113_oneDim';

%% ����ԭʼ����
dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_yuan = getfield(dat, name);    %�����ֶ�����ȡ����

data = data_yuan - mean(data_yuan);   %ȥ��ֱ������

%% STFT
len = length(data);

%���windowΪһ��������x�����ֳ�window���ĶΣ�ÿ��ʹ��Hamming�������Ӵ���
window = 10*24/3;    %��������   

%������Ϊһ��С��window��length(window)��������
%����˼Ϊ�������ڴ�����β����ͷ�ģ������������н��������ص��Ĳ��֡�
% �ص�Ϊ0��window����10*24ʱ������ʱ����7��һ�����һ��   ���ص���Ϊ0.5  ��ʱ����14��
noverlap = window*0;    %ÿһ�ε��ص�������,


f_len = 10;     %Ƶ����ּ���
f = linspace(0, 1e10, f_len);   %�ڶ�����ΪƵ������ʾ��Χ

%��ɢ����Ҷ����
nfft = window;

%����Ƶ��
fs = 10*24; %һ���ۺϳ�1s   ����Ƶ�� 10*24


[s, f, t] = spectrogram(data, window, noverlap, nfft, fs);
figure('color','w');


%% �������ܶ� db/hz
% imagesc(t, f./(fs/2), 10*log10(abs(s)/len));   %�������ܶ�
% title('�ۺϵ糡ǿ�����й������ܶ�ͼ','FontSize',18);
% xlabel('����','FontSize',18); ylabel('��һ��Ƶ��','FontSize',18);
% colorbar;
% ylabel(colorbar,'�������ܶ� [dB/HZ]','FontSize',18);
% colormap(jet);


% %% ��ȫ�ַ�ֵ�����ȹ�һ��
% imagesc(t, f./(fs/2), 10*log10(abs(s)/max(max(abs(s)))));   %Ƶ�׷��ȹ�һ��
% %surf(t, f./(fs/2), 10*log10(abs(s)/max(max(abs(s)))));
% title('�ۺϵ糡ǿ������Ƶ��ͼ','FontSize',18);
% xlabel('����','FontSize',18); ylabel('��һ��Ƶ��','FontSize',18);
% colorbar;
% ylabel(colorbar,'��һ��Ƶ�׷��� [dB]','FontSize',18);
% colormap(jet);

    
%% �����շ�ֵ�����ȹ�һ��
max_col = repmat(max(abs(s),[],1), size(s,1), 1);
s_1 = abs(s)./max_col;
imagesc(t, f./(fs/2), 10*log10(s_1) );   %Ƶ�׷��ȹ�һ��
%title('�ۺϵ糡ǿ������Ƶ��ͼ','FontSize',20);
xlabel('Time[Day]','FontSize',20); ylabel('Normalized frequency','FontSize',20);
colorbar;
ylabel(colorbar,'Normalized STFT [dB]','FontSize',20);
colormap(jet);

%% ��ʾ[������]��ǩ����
yLabels = {'0-8', '8-16', '16-24'};  % ����ӵı�ǩ
lenlab = length(yLabels);
for i = 0 : length(yLabels)*7-1
    if mod(i,3)+1==2
        offset = 0.005;
    elseif mod(i,3)+1==1
        offset = 0.05;
    else
        offset = 0;
    end
    text(1/lenlab * i+0.06+offset, 1-0.05, yLabels(mod(i,3)+1));   % ���ı��ķ�ʽ��ӣ�λ�ÿ����Զ���
    text(1/lenlab * i+0.045, 1-0.025, 'o''clock','FontSize',15);
end



% x��λ���Ϸ�
ax = gca;
ax.XAxisLocation = 'top';
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca,'LineWid',1.5);  %�����߿�
set(gca, 'GridAlpha', 1);  % ����͸����
set(gca,'fontsize',20);
%% Ƶ��������ȡ
norm_freq_mat = repmat(f./(fs/2), 1, size(s, 2));%��һ��Ƶ�ʾ���

%ƽ���糡ǿ�� MS
MS = [];
size(s, 2)
for i=1:size(s, 2)
    MS = [MS mean( data_yuan((i-1)*fs/3+1:i*fs/3) )];
end

%ǰ����г����ֵ����Ƶ��λ��
abs_s = abs(s);
B = sort(abs(s),'descend');
Amax1 =B(1,:);
Amax2 =B(2,:);
Amax3 = B(3,:);
index = [];
for i=1:size(s, 2)
    temp = [find(abs_s(:,i)==Amax1(i)); find(abs_s(:,i)==Amax2(i)); find(abs_s(:,i)==Amax3(i));];
    index = [index temp];
end

%ƽ��Ƶ�� MF
MF = mean(abs(s), 1);

%����Ƶ�� FC
numer = sum(norm_freq_mat.*abs(s));
denomin = sum(abs(s));
FC = numer./denomin;
FC_mat = repmat(FC, size(s, 1), 1);%����Ƶ����չ����

%����Ƶ��MSF
numer = sum((norm_freq_mat.^2).*abs(s));
denomin = sum(abs(s));
MSF = numer./denomin;

%Ƶ�ʷ��� VF
numer = sum(((norm_freq_mat - FC_mat).^2).*abs(s));
denomin = sum(abs(s));
VF = numer./denomin;

% �ϲ����
result = [MF; 
    FC; 
    MSF; 
    VF];
%imagesc(result)
save('E:\Desktop\dianci\Python_code\mat\freq_feat.mat','result')

%% ָ����ʾ
% �������·���ʾ FCָ��
text(-0.3, 1+0.05, 'FC:','FontSize',20);  %��ʾָ������
reshape_mat = reshape(FC, 3, 7);  %������ÿ��FC���ֵ
[max1, loc_max] = max(reshape_mat,[],1);   %max  ���ֵ  loc���ֵλ��
[min1, loc_min] = min(reshape_mat,[],1);   %min  ��Сֵ  loc��Сֵλ��
for i = 1 : size(FC, 2)
    if mod(i-1, 3)+1 == loc_max(floor((i-1)/3)+1)
        % ÿ������ֵʱ��θ�����ʾ
        text(1/lenlab * (i-1)+0.045, 1+0.05, num2str(FC(1, i),'%.3f'),'backgroundcolor', [255,64,0]./255 , 'edgecolor', 'white','FontSize',12); 
    elseif mod(i-1, 3)+1 == loc_min(floor((i-1)/3)+1)
        text(1/lenlab * (i-1)+0.045, 1+0.05, num2str(FC(1, i),'%.3f'),'backgroundcolor', [0,191,255]./255, 'edgecolor', 'white','FontSize',12);     
    else
        text(1/lenlab * (i-1)+0.045, 1+0.05, num2str(FC(1, i),'%.3f'),'backgroundcolor', [154,254,46]./255, 'edgecolor', 'white','FontSize',12);   % ���ı��ķ�ʽ���
    end
end


% �������·���ʾ ��ֵλ��
text(-0.45, 1+0.05*2, 'index:','FontSize',20);  %��ʾָ������
for i = 1 : size(s, 2)
    context = [num2str(index(1, i)) ',' num2str(index(2, i)) ',' num2str(index(3, i))];
    text(1/lenlab * (i-1)+0.045, 1+0.05*2+0.01, context,'edgecolor', 'white','FontSize',12);
end


