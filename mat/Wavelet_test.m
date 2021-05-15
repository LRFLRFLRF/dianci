
load 106to114_oneDim.mat
x = data_1;

%% ������������
SNR = [];
cengshu = 4;
jieshu = 10;
for j = 1:cengshu
    for i = 1:jieshu
        %�źŷֽ�
        [c, l] = wavedec(x, j, ['db', num2str(i)]);

        %�ع��ź�
        c_new = c;
        c_new(l(2):end) = 0;  %ֻѡ�����ϵ��a
        y = waverec(c_new, l, ['db', num2str(i)]);

        %���������
        M = mean(y);   %ƽ��ֵ
        SD = std(y, 1);
        %SNR = [SNR 10*log10(M/SD)];
        SNR = [SNR snr(y,x-y)];
    end
end
SNR = reshape(SNR, jieshu, cengshu)';
snr_max = max(max(SNR));
[x_max, y_max] = find(SNR==max(max(SNR)));
disp(['������' , num2str(x_max)])
disp(['������', num2str(y_max)])

%% ������������ѡ��db������
%�źŷֽ�
y_max = 8;
x_max = 4;
[c, l] = wavedec(x, x_max, ['db', num2str(y_max)]);

%�����ź�a�ع�
c_new = c;
c_new(l(2):end) = 0;  %ֻѡ�����ϵ��a
a = waverec(c_new, l, ['db', num2str(y_max)]);

%ϸ���ź�D�ع�
coef = [];    %�����ź�a   ��ϸ���ź�d  ��coef����
x_cursor = 0;
for i=1:(length(l)-1)
    c_new = c;
    c_new(1 : x_cursor) = 0;
    c_new((l(i) + x_cursor + 1) : end) = 0;
    coef = [coef  waverec(c_new, l, ['db', num2str(y_max)])];
    x_cursor = l(i) + x_cursor;
end



%% ����ԭ�ź�coef  ��Ⱦɫ
figure;
subplot(211);
rgb = ['r','g','b','c','y','k','m','r','g','b','c','y','k','m'];
x_cursor = 1;
for i=1:(length(l)-1)
    x_label = x_cursor : (l(i) + x_cursor - 1);
    plot(x_label, c(x_cursor : (l(i) + x_cursor - 1)), rgb(i));
    hold on;
    x_cursor = l(i) + x_cursor - 1;
end
xlim([1 2015]);
% ���ƽ��Ʋ���
subplot(212);
plot(a);
ylim([0.1 0.5]);

%% ����
data = y';
save('E:\Desktop\dianci\Python_code\mat\mat_xls_file\wp_4_db8_rec.mat','data');


%% ϸ���ź�D��fftƵ�׼���
Fs = 48*5;            % ����Ƶ��                  
T = 1/Fs;             % Sampling period   
figure('color','w');
for i =1 :size(coef,2)
    s = coef(:, i);   %�����ź�
    n = length(s);             % Length of signal
    s = s - mean(s);   %ȥ��ֱ������
    Y = fft(s, n);
    %%%%��ͼ
    % Y��Y����=a����b��   ����Y = a + ib
    Pyy = Y.*conj(Y)/n;
    %Ƶ������f  ���У�0��n/x����x����plot��ʾƵ�ʷ�Χ         Fs/nƵ�׷ֱ���
    f = Fs/n*(0:n/2);
    subplot(str2num([num2str(size(coef,2)) '1', num2str(i)]));
    plot(f,Pyy(1:n/2+1) , 'color', 'black', 'LineWidth', 1.5)
    set(gca,'XTick',[0:5:150]);%����Ҫ��ʾ����̶�
    if i == 1
        title(['�����ź�A' num2str(size(coef,2) -1) 'Ƶ��ǿ��'],'FontSize',18)
    else
        title(['ϸ���ź�D' num2str(size(coef,2) - i +1) 'Ƶ��ǿ��'],'FontSize',18)
    end
    hold on;
end
xlabel('Ƶ�� [1/24h]','FontSize',18);