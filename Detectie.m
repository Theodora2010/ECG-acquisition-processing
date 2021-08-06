function [perioada,varfuri] = Detectie(y,t)
    l = numel(y);               
    Fs = round(l/t);                % Frecvența de eșantionare
    tv = linspace(0,l,l)/Fs;        % Vectorul timp
    z = bandpass(y,[10 50],Fs);     % Filtru trece banda
    % Găsire vârfuri inițiale
    [Pks,Locs] = findpeaks(z,tv, 'MinPeakHeight',50, 'MinPeakDistance',0.5);
    m = zeros();
    Pks1 = zeros();
    Locs1 =zeros();
    %În fereastra de 5 vârfuri se făsește pragul estimativ
    for i = 5:numel(Pks)
        % V=  [(∑_t-4 ^ t (R)-MAX(R))/4]∙55%
        S = 0;
        m = max(Pks(i-4:i));
        for j = i-4:i
            S = S+(Pks(j));
        end
        V = ((S-m)/4)*(55/100);
        % Cu ajutorul pragului se găsesc vârfurile undelor R
        [Pks1,Locs1] = findpeaks(z(1:(Locs(i))*Fs+1),tv(1:(Locs(i)*Fs+1)), 'MinPeakHeight',V, 'MinPeakDistance',0.5);
    end
    % Afișarea semnalului filtrat cu undele R detectate
    figure, plot(tv,z),hold on, plot(Locs1,Pks1,'ro'),hold off;
    % În caz de eroare se estimează poziția lor pe semnalul inițial
    P = zeros();
    for i = 1:numel(tv)
        for j = 1:numel(Locs1)
            if tv(i) == Locs1(j)

                if y(i)<y(i-1)
                    P(j) = y(i-1);
                else
                    if y(i)<y(i+1)
                        P(j) = y(i+1);
                    else
                        P(j) = y(i);
                    end
                end
            end
        end
    end
    % Se afișează semnalul inițial și undele detectate
    figure,plot(tv,y), hold on, plot(Locs1,P,'ro'),hold off
    % Calculare Frecvență cardiacă
    a = mean(diff(Locs1));          % Distanța medie între undele R - R
    bpm = round(60/a)               % Calcul Frecvența cardiacă medie
    % Calcul frecvența cardiacă în funcție de timp
    g = zeros();
    for i = 2:numel(P)
        r = Locs1(i)-Locs1(i-1);
        b = round(60/r);
        g(i-1)= b;
    end
    figure,
    plot(Locs1(1:end-1),g)          % Afișare frecvență cardiacă în funcție de timp
    perioada = P;
    varfuri = Locs1;
end