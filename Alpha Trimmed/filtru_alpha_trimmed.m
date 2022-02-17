function [rez] = filtru_alpha_trimmed(nume,d,vi)
    % I: nume - numele fisierului cu imaginea de filtrat
    % d - dimensiune filtru
    % vi - cate valori se ignora din vectorul cu pixelii sortati; vi valori
    % din stanga si vi valori din dreapta
    % E: -
    %
    % exemplu de apel
    % filtru_alpha_trimmed('car_gray_zg_SPN.png',5,2);
    % filtru_alpha_trimmed('car_gray_zg_SPN.png',3,1);
    
    % verificam daca imaginea e de tip RGB -> convertim in imagine
    % monocroma
    I=imread(nume);
    [m,n,p]=size(I);
    if p>1
        I=rgb2gray(I);
    end;
    
    % img se extinde cu o bordura egala cu jumatate din dimensiunea mastii
    l=m+d-1;            % dimensiuni imagine extinsa
    c=n+d-1;
    t=(d+1)/2;          % coordonate colt stinga sus imagine in matr. extinsa
    fc=zeros(l,c);      % imagine extinsa
    fc(t:m+t-1,t:n+t-1)=double(I);
    g=zeros(l,c);
    
    
    % aplicare filtru de ordine
    for x=1:m
        for y=1:n
            r=fc(x:x+d-1,y:y+d-1);
            xx=reshape(r,[d*d,1]); % dxd linii, o col
            yy=sort(xx);
            % filtru alpha trimmed
            s = 0;
            for k=(1+vi):(d*d-vi)
                s = s + yy(k);
            end;
            g(x+t-1,y+t-1) = s / (d*d - 2*vi);
            % end filtru alpha trimmed
        end;
    end;
    % extragere imagine din matricea extinsa
    rez=uint8(g(t:m+t-1,t:n+t-1));
    
    % optional, vizualizarea celor doua imagini
    figure
        imshow(I);
        title('Imaginea perturbata');
    figure
        imshow(rez);
        title('Imaginea filtrata alpha trimmed');
end


