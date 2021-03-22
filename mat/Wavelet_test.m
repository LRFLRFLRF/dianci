

SNR = [];
%������������
for i = 1:10
    load 106to114_oneDim.mat
    x = data_1;

    %�źŷֽ�
    [c, l] = wavedec(x, 4, ['db', num2str(i)]);

    %�ع��ź�
    c_new = c;
    c_new(l(2):end) = 0;  %ֻѡ�����ϵ��a
    y = waverec(c_new, l, ['db', num2str(i)]);
    
    %���������
    M = mean(y);   %ƽ��ֵ
    SD = std(y, 1);
    SNR = [SNR 10*log10(M/SD)];
end
[snr_max, index_max] = max(SNR);



%% ������������ѡ��db������
%�źŷֽ�
[c, l] = wavedec(x, 4, ['db', num2str(index_max)]);
c_new = c;
c_new(l(2):end) = 0;  %ֻѡ�����ϵ��a
y = waverec(c_new, l, ['db', num2str(index_max)]);

%����ԭ�ź�coef  ��Ⱦɫ
figure;
subplot(211);
rgb = ['r','g','b','c','y','k','m'];
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
plot(y);
ylim([0.1 0.5]);


%����
data = y';
save('E:\Desktop\dianci\Python_code\mat\mat_xls_file\wp_4_db8_rec.mat','data');
