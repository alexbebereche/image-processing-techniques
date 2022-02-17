function [ alpha ] = filtru_BHP(nume,D0,ordin_k,tip)
    % I: nume - numele fisierului cu imaginea, 
    %    D0 - raza filtrului
    %    ordin_k - ordin
    %    tip - tipul fisierului pentru imaginea rezultat
    % E: alpha - procentul din puterea spectrala totala pastrata
    
    % Exemple de apel
    % filtru_BHP('Lena_gs.bmp', 50,2, 'png')
    % filtru_BHP('Lena_gs.bmp', 50,1, 'png')
    % filtru_BHP('Lena_gs.bmp', 100,2, 'png')
    
    poza=imread(nume);
    [m,n,p]=size(poza);
    % se lucreaza pe imagine gray-scale, 1 plan
    if p>1
        plan=rgb2gray(poza);
    else
        plan=poza;
    end;
    figure
        imshow(plan);
        title('Imaginea initiala');
    
    % l, c - dimensiuni expandare
    % m1, n1 - linia si coloana de unde incepem copierea imaginii initiale 
    % in imaginea expandata
    
    l=2*m;
    c=2*n;
    m1=fix(m/2)+1;
    n1=fix(n/2)+1;
    
    % 1. expandare imagine
    f=zeros(l,c);
    f( m1:m+m1-1 , n1:n+n1-1 )=double(plan);
        
    % 2. centrarea imaginii expandate
    fc=centrare(f);
  
    % 3. transformarea Fourier
    fcTFD=fft2(fc);
    
    % 4. construire functie filtru BHP
    h=zeros(l,c);
    for i=1:l
        for j=1:c
             h(i,j)=1/(1+(D0/Dist(i,j,l,c))^(2*ordin_k));
        end;
    end;

    
    % 5. aplicare functie filtru
    gTFD=fcTFD.*h;
    
    % 6. reconstruire imagine filtrata
    gc=real(ifft2(gTFD));
    
    % 7. eliminarea centrarii
    % g=centrare(gc);
    g=gc;
    for i=1:l
        for j=1:c
            g(i,j)=gc(i,j)*(-1)^(i+j);
        end;
    end;
    
    % 8. extragere imagine rezultat

     rez1= g(m1:m+m1-1,n1:n+n1-1);
     
     
%     % trecere la imaginea binara
%     for i=1:m
%         for j=1:n
%             if(rez1(i,j)>0)
%                 rez1(i,j)=255;
%             end;
%         end;
%     end;
    rez=uint8(rez1);


    figure
        imshow(rez);
        title(['Imaginea filtrata BHP cu raza ' num2str(D0)]);
  
    fi=[nume '-' num2str(D0) '.' tip];

    imwrite(rez, fi, tip);
    
    alpha=calcul_alpha(fcTFD, D0);
end

function [d]=Dist(i,j,l,c)
    % calcul distanta pentru punctul (i,j) fata de centru in imaginea (l,c)
    l1=l/2;
    c1=c/2;
    d=sqrt((i-l1)^2+(j-c1)^2);
end

function [alpha]=calcul_alpha(F,D0)
    % determinarea procentului din puterea spectrala totala pastrata
    
    [l,c]=size(F);
    %calculul puterii spectrale in fiecare punct
    P=zeros(l,c);
    for i=1:l
        for j=1:c
            P(i,j)=abs(F(i,j))^2;
        end;
    end;

    %calculul puterii spectrale totale
    PT=sum(sum(P));

    %calculul puterii spectrale considerate in total, pentru raza D0
    Pincl=0;
    for i=1:l
        for j=1:c
            if(Dist(i,j,l,c)<=D0)
                Pincl=Pincl+P(i,j);
            end;
        end;
    end;

    %calculul procentului alpha
    alpha=100*Pincl/PT;
end

function [g]=centrare(f)
    [m,n]=size(f);
    g=zeros(m,n);
    for l=1:m
        for c=1:n
            g(l,c)=f(l,c)*(-1)^(l+c);
        end;
    end;
end
