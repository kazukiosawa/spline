%de Boorによる3次の双スプラインの定数a0,0~a3,3を求める連立方程式で使用する行列を取得
function[Q] = matrixForEquations()
    degree = 3;  %3次の双スプライン
    size = (degree + 1)^2;
    Q = zeros(size, size);    
    for row = 1 : size
        parameters = parametersForDifferential(row);
        for col = 1 : size
            deg_x = floor((col - 1) / 4); % xの次数
            deg_y = rem((col - 1), 4);    % yの次数
            Q(row, col) = coefficientByDifferential(deg_x, deg_y, parameters);
        end
    end
end

%　行数ごとに、微分に関わる各種パラメータを取得
function[parameters] = parametersForDifferential(row)
    val_x = rem(floor((row - 1)/ 2), 2); % (x-xi)/(xi+1-xi)の値
    val_y = rem((row - 1), 2);           % (y-yi)/(yi+1-yi)の値
    dif_x = rem(floor((row - 1)/ 4), 2); % xでの微分階数
    dif_y = floor((row - 1)/ 8);         % yでの微分階数
    parameters = struct('val_x', val_x,'val_y', val_y, 'dif_x', dif_x, 'dif_y', dif_y);
end

%  微分による係数を取得
function[coefficient] = coefficientByDifferential(deg_x, deg_y, parameters)
    val_x = parameters.val_x;
    val_y = parameters.val_y;
    dif_x = parameters.dif_x;
    dif_y = parameters.dif_y;  
    flag = coefficientIsValiable(deg_x, deg_y, dif_x, dif_y, val_x, val_y);
    if flag
        coefficient = coefficientSize(deg_x, deg_y, dif_x, dif_y);
    else
        coefficient = 0;
    end
end

%  係数の大きさを取得
function[size] = coefficientSize(deg_x, deg_y, dif_x, dif_y)
    if dif_x == 0 && dif_y == 0
        size = 1;
    elseif dif_x == 1 && dif_y == 0
        size = deg_x;
    elseif dif_x == 0 && dif_y == 1
        size = deg_y;
    else
        size = deg_x * deg_y;
    end
end

%  係数が有効か判断
function[flag] = coefficientIsValiable(deg_x, deg_y, dif_x, dif_y, val_x, val_y)
    if val_x == 0 && val_y == 0
        flag = (deg_x == dif_x && deg_y == dif_y);
    elseif val_x == 0 && val_y == 1
        flag = (deg_x == dif_x);
    elseif val_x == 1 && val_y == 0
        flag = (deg_y == dif_y);
    else
        flag = true;
    end
end

