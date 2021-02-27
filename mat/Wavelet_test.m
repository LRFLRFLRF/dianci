load 106to114_oneDim.mat
x = data_1;

%�źŷֽ�
[c, l] = wavedec(x, 5, 'db10');

%����ԭ�ź�coef  ��Ⱦɫ
figure;
subplot(211);
rgb = ['r','g','b','c','y','k','m'];
length(l)
x_cursor = 1;
for i=1:(length(l)-1)
    x_label = x_cursor : (l(i) + x_cursor - 1);
    plot(x_label, c(x_cursor : (l(i) + x_cursor - 1)), rgb(i));
    hold on;
    x_cursor = l(i) + x_cursor - 1;
end
xlim([1 2015]);

 

%�ع��ź�
c_new = c;
c_new(l(2):end) = 0;  %ֻѡ�����ϵ��a
y = waverec(c_new, l, 'db10');
subplot(212);
plot(y);
ylim([0.1 0.5]);

