function y = Procesare(x,t)
figure, plot(x)                 % Afișare semnal achiziționat
Fs = round(numel(x)/t);         % Frecvența de eșantionare
% Filtru trece sus
y = highpass(x,0.5,Fs,'StopbandAttenuation',60);
figure, plot(y)                 % Rezultatul filtrului trece- sus
% Filtru Wavelet
wname = 'db4';                  % Funcția Wavelet mamă db4
level = 5;                      % Descompunere în 4 coeficienți + aproximare
wt = modwt(y,level,wname);      % Descompunere
wtrec = zeros(size(wt));
wtrec(2:4,:) = wt(2:4,:);       % Păstrarea doar a nivelurilor 2,3 și 4
y = imodwt(wtrec,'db4');        % Transformata inversă
figure, plot(y)                 % Rezultatul filtrării Wavelet
% Filtru cu medie mobilă
B = 1/3*ones(1,3);              % Fereastră de 3 eșantioane
out = filter(B,1,y);            % Filtrarea cu filtru cu medie mobilă
for i = 1:numel(y)              % Păstrarea amplitudinilor mari și mici
    if y(i) < 50 && y(i) > -10
        out(i) = out(i);
    else
        out(i) = y(i);
    end
end
y = out;
figure, plot(y)                 % Rezultatul filtrării

end
