function pi_approx = NeedleSimulation(needle_count, n_lines, n, do_plot)
% Hany parhuzamos vonalunk van
line_d = 1 / n_lines;        % A parhuzamos egyenesek kozotti tavolsag
needle_l = line_d - 0.0001;

% Helyet foglalunk egy matrixnak, ami az egyenesek kezd es veg pontjait tarolja
line_coords = zeros(n_lines, 4);
line_x = line_d / 2;
for i = 1 : n_lines
    line_coords(i, :) = [line_x line_x 0 1];   % (line_x, 0) es (line_x, 1) pontokbol allo egyenes
    line_x = line_x + line_d;
end

% Parhuzamos vonalak kirajzolasa
if(do_plot)
    axis([0 1 0 1]);    % Minket csak ez a resz erdekel [0,1] x [0,1]
    hold on;
    for i = 1 : n_lines
        plot(line_coords(i, 1 : 2), line_coords(i, 3 : 4), 'k');
    end
end

% Kovetjuk, hogy hany tu metszette az egyeneseket
hits = 0;

% Egy szimulacio ismetles (Egy tu ledobasa)
for needle = 1 : needle_count
    % 'Ledobunk' egy tut es megkapjuk a kezdeti es veg koordinatakat
    [needle_x, needle_y] = DropNeedle(needle_l);

    % Tu kirajzolasa
    if(do_plot && (mod(needle, n) == 0))
        plot(needle_x, needle_y);
        % Informacio megjelenitese
        title(['Neddles: ' num2str(needle) ' | Hits: ' num2str(hits) ' | \pi: ' num2str(2 * needle_l * needle / (line_d * hits))]);
        drawnow;
    end
    
    for i = 1 : n_lines
        % Megtalaljuk, ha letezik metszespontja az adott egyenessel
        if((needle_x(1) <= line_coords(i, 1)) && (needle_x(2) >= line_coords(i, 1)) || ...
           (needle_x(2) <= line_coords(i, 1)) && (needle_x(1) >= line_coords(i, 1)) )
            hits = hits + 1; break;
        end
    end
end

% Pi kozelites kiszamitasa
pi_approx = 2 * needle_l * needle_count / (line_d * hits);
format long; disp("π: " + pi);
disp("Sajat pi kozelites: " + pi_approx);
disp("Abszolut hiba: " + abs(pi - pi_approx));

end

function [needle_x, needle_y] = DropNeedle(needle_l)
% n_lines -> Hany parhuzamos vonalunk van (Kell, hogy meghatarozzuk a tuk
% koordinatainak generalasi intervallumat
% line_d -> A parhuzamos vonalak kozotti tavolsagok
% needle_l -> Egy tu hossza

% Milyen intervallum kozott vannak az x, y koordinatak
needle_half_l = needle_l / 2;
x_y_start = needle_half_l;   % Azert nem 0, ugyanis ha 0-ra generalnank, akkor lehetseges, hogy kimenne a plotrol, igy pedig maximalisan csak erinti a szelet
x_y_end = 1 - needle_half_l;    % Ugyanugy mint felul

% Generalunk egy random szoget [0, pi] kozott (Egy Theta) szog
theta = URealRNG([], 'ULEcuyerRNG', 0, pi, 1);

% Generalunk egy pontpart, ami a tu egyik vegpontjanak a koordinatait jelkepezi
needle_x1 = URealRNG([], 'ULEcuyerRNG', x_y_start, x_y_end, 1);
needle_y1 = URealRNG([], 'ULEcuyerRNG', x_y_start, x_y_end, 1);

% Kiszamitjuk a masik vegenek a koordinatait
needle_x2 = needle_x1 + (needle_l * cos(theta));
needle_y2 = needle_y1 + (needle_l * sin(theta));

% Tehat a vegso koordinataink
needle_x = [needle_x1 needle_x2];
needle_y = [needle_y1 needle_y2];                                                                               
end