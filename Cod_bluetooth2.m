function [x,t] = Cod_bluetooth2()
    b = instrfind('Type', 'bluetooth', 'Name', 'Bluetooth-HC-05:1', 'Tag', '');
    if isempty(b)
        b = Bluetooth('HC-05', 1);  % Găsirea dispozitivului Bluetooth utilizat
    else
        fclose(b);
        b = b(1);
    end
    global stop
    fopen(b);                       % Deschiderea conexiunii cu HC 05
    fig = figure;
    h = animatedline;               % Deschiderea unei figuri animate
    ax = gca;
    ax.YGrid = 'on';
    i=1;
    x = zeros();                    % Inițializarea unui vector
    stop = false;
    startTime = datetime('now');    % Inițializarea variabilei timp
    set(fig,'KeyPressFcn',@keypressfcn);

    while ~stop
        x(1,i) = str2double(fscanf(b));     % Citirea eșantioanelor trimise de Bluetooth
        t = time2num((datetime('now') - startTime),'seconds');  % Aflarea timpului actual
        if isnan(x(1,i))    
            x(1,i) = 0;             % În cazul în care există o eroare debug
        end
        addpoints(h,t,x(1,i))       % Adăugarea eșantioanelor pe grafic
        ax.XLim = [t-3 t];          % Mișcarea continuă a graficului pe axa OX
        i = i+1;
        drawnow limitrate           % Desenarea semnalului pe grafic
        pause(0.0001)
    end
end
function keypressfcn(~, event)
    global stop
    stop = true;
    disp(event.Key);
end