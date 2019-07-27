function tc = orthoProjectionOnCurve(x0, y0, X, Y, dXdt, dYdt, eps)
syms t;
d2Xdt = eval(['@(t)' char(diff(dXdt(t)))]);
d2Ydt = eval(['@(t)' char(diff(dYdt(t)))]);
f = @(t) X(t) * dXdt(t) + Y(t) * dYdt(t) - x0 * dXdt(t) - y0 * dYdt(t); 
g = @(t)  dXdt(t)^2 + X(t) * d2Xdt(t) + dYdt(t)^2 + Y(t) * d2Ydt(t) - x0 * d2Xdt(t) - y0 * d2Ydt(t);
curv_num =@(t) abs(dXdt(t) * d2Ydt(t) - dYdt(t)*d2Xdt(t));
curv_den = @(t) (dXdt(t)^2 + dYdt(t)^2)^1.5;
curv = @(t) curv_num(t)/curv_den(t);

flag1 = 1;
sign = curv(0);
for i = 1:200
    if sign >= 0
        if curv(i/200) < 0
            flag1 = 0;
        end
    end
    if sign <= 0
        if curv(i/200) > 0
            flag1 = 0;
        end
    end
end

if flag1 == 1
    t1 = 0;
    min_dist = (X(t1)-x0)^2 + (Y(t1) - y0)^2;
    dist_part = 100;
    for i = 1:dist_part
        dis = (X(i/dist_part) - x0)^2 + (Y(i/dist_part)-y0)^2;
        if dis <= min_dist
            min_dist = dis;
            t1 = i/dist_part;
        end
    end
    y = t1;
    max_ite = 1000;
    f(y);
    g(y);
    for i = 1:1:max_ite
        a = f(y);
        b = g(y);
        c =  a/b;
        y = y - c;
        num = (X(y)- x0)*dXdt(y) + (Y(y) - y0) * dYdt(y);
        den = ((X(y)- x0)^2 + (Y(y) - y0)^2)^0.5 * (dXdt(y)^2 + dYdt(y)^2)^0.5;
        error = num/den;
        if(error <= eps)
            break;
        end        
    end
    tc = y;
end

if flag ~= 1
    
    max_ite = 10000;
    min_dist = 1000000000000000;
    min = min_dist;
    t_min = 0;
    for j = 1:1000
        y = j/1000;
        for i = 1:1:max_ite
            a = f(y);
            b = g(y);
            c =  a/b;
            y = y - c;
            num = (X(y)- x0)*dXdt(y) + (Y(y) - y0) * dYdt(y);
            den = ((X(y)- x0)^2 + (Y(y) - y0)^2)^0.5 * (dXdt(y)^2 + dYdt(y)^2)^0.5;
            error = num/den;
            if(error <= eps)
                break;
            end
            
        end
        min_dist = ((X(y)-x0)^2 + (Y(y) - y0)^2)^0.5;
        if min_dist <= min
            min = min_dist;
            t_min = y;
        end
    end
    tc = t_min;
end

