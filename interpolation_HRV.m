F_s = 360;


%RR intervals
y = zeros(1,length(ecg_sig)); 
R_t = zeros(1,length(ecg_sig)); %this vector will contain RR intervals
for i=41:length(ecg_sig)-41
    check=0;
    for j=i-40:i+40
    if x(i)>=x(j);
    else
        check=1;
    end
    end
    if check==0
        y(i)=x(i);
    end
end
for i=1:length(ecg_sig)
    if y(i)<400
        y(i)=0;
    end
end;
t_R = find(y); %t_R contains indices where y is non zero i.e. location R points
for i = 1:length(t_R)-1
    RR(t_R(i)) = (t_R(i+1)-t_R(i))/F_s; %calculation of RR intervals
    RR_int(i)= RR(t_R(i));
    len_int(i)=y(t_R(i));
    HR(i)=1/RR(i);
    
end


% %interpolation
% %hrvn = zeros(1,length(R_t));
% Dt = (1/360);
% sigpos = RR;
% b = [1 -1];
% hrv1 = filter(b,1,sigpos);
% for t = 0:Dt:sigpos(length(sigpos))
%     if t<sigpos(1)
%         vmin=1;y
%     else
%         v1=find(sigpos<=t);
%         vmin=v1(length(v1));
%     end
%     v1 = find(sigpos>=t);
%     vmax = v1(1);
%     k=round(t/Dt)+1;
%     if vmin==vmax
%         hrvn(k)=hrv1(vmin);
%     else
%         hrvn(k)=(hrv1(vmax)*(t-sigpos(vmin))+hrv1(vmin)*(sigpos(vmax)-t))/(sigpos(vmax)-sigpos(vmin));
%     end
% end

%interpolating signal by 2

y = interp(RR_int,2);                        % Interpolated Signal
%subplot(211);
%stem(RR_int);
%title('Original Signal');
%subplot(212);
%stem(y);
%title('Interpolated Signal');
%plot(y) %plot interpolated RR
[pxx,f_k] = periodogram(y,rectwin(length(y)),length(y),2,'power'); %to plot PSD
plot(f_k,10*log10(pxx));

var1=0;
var2=0;
for i = 1:length(f_k)
   if(0.04<f_k(i)<0.15)
       var1=var1+pxx(i);
   end
   if (0.15<f_k(i)<0.4)
       var2=var2+pxx(i);
   end
end

ratio = var2/var1;