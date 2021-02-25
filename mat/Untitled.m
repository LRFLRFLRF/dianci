biao_name = '1-1;SGRAM;825-835MHZ;09-Nov-2020 20_47_40';
file_name = ['F:\Desktop\dianci\sample_data\',biao_name,'.mat'];
%file_name = ['F:\Desktop\dianci\sample_data\2020_10_23',biao_name,'.csv'];
data = load(file_name);
[m, n] = size(data.Y);
A = data.Y;
a = abs(A);
figure('Name', 'IQ');
plot(a);



% NumberSamples = csvread(file_name, 11, 1, [11, 1, 2, 2])
% NumberRecords = csvread(file_name, biao_name, 'B4')
% I = [];
% Q = [];
% for j=0:NumberRecords-1
%     clear i q;
%     ['A',num2str(11+NumberSamples*j+6*j),':A',num2str(11+NumberSamples*(j+1)+6*j)]
%     i = csvread(file_name, biao_name, ['A',num2str(11+NumberSamples*j+6*j),':A',num2str(11+NumberSamples*(j+1)+6*j)]);
%     %plot(i)
%     size(i)
%     I = [I;i];
%     ['B',num2str(11+NumberSamples*j+6*j),':B',num2str(11+NumberSamples*(j+1)+6*j)]
%     q = csvread(file_name, biao_name, ['B',num2str(11+NumberSamples*j+6*j),':B',num2str(11+NumberSamples*(j+1)+6*j)]);
%     size(q)
%     Q = [Q;q];
% end
% figure('Name', 'I');
% plot(I);
% figure('Name', 'Q');
% plot(Q);
% %figure('Name', 'I+Q');
% %plot(I + Q);
% figure('Name', 'IQ');
% plot(sqrt(I.^2 + Q.^2));

