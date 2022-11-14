clc
format long
clear
pkg load signal;

function [P1,f] = plot_fft(y,fs)
    out = fft(y);
    L = length(y);
    P2 = abs(out/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = fs*(0:(L/2))/L;
    plot(f,P1)
endfunction

[x,fs] = audioread("la_muerte_del_angel_power_noise.wav");
length(x);
get(0,'screensize')
figure(1, 'position',[460,540,500,500])
subplot(2,1,1)
[P1,f] = plot_fft(x,fs);
title("Contenido Espectral");
subplot(2,1,2)
plot(f(1:length(x)/40),P1(1:length(x)/40))
title("Ampliacion del Espectro")
figure(2,'position',[960,1040,500,500])

for i = 0:3
    window = fs*2;
    subplot(2,2,i+1);
    str_i = 1+i*window;
    end_i = (i+1)*window;
    [P,fsub] = plot_fft(x(1+i*window:(i+1)*window),fs);
    plot(fsub(1:length(P)/20),P(1:length(P)/20))
end

%FILTER
ff = 60;
fi = 90;
len = fs/60;
rad = (0.9)^len;
z = zeros(1,len+1);
p = zeros(1,len+1);
z(1) = 1;
z(len+1) = -(cos(2*pi*ff/fs)+j*sin(2*pi*ff/fs));
p(1) = 1;
p(len+1) = -rad*(cos(2*pi*fi/fs)+j*sin(2*pi*fi/fs));

figure(3,'position', [460,40,500,500])
zplane(z,p)
title("Diagrama de Polos y Ceros")

figure(4,'position', [960,40,500,500])
[h,w] = freqz(z,p,fs,'half',fs);
freqz_plot(w,h)

out = filter (z,p,x);
audiowrite("la_muerte_del_angel_filtered.wav",out,fs)

pause
