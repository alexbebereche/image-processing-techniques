function [ imagine_modificata ] = unsharp_masking(nume, masca)
%I: nume - numele imaginii
    % masca - numele fisierului .txt asociat mastii
    
% E: imaginea modificata
% exmplu apel unsharp_masking('vulpea si marmota.jpg','m9');
imagine_nivelata = filtrare_medie(nume, masca);
imagine_originala=imread(nume);

figure
imshow(imagine_originala);
title('Imaginea originala');

imagine_modificata = (imagine_originala - imagine_nivelata) + imagine_originala;
figure
imshow(imagine_modificata);
title('Imaginea modificata');

imwrite(imagine_modificata, "vulpea si marmota - unsharp_masking.png"); % direct save ca .png
end

function [ rez ] = filtrare_medie( nume,filtru )
    % filtru medie pentru prelucrarea unei imagini grayscale/RGB 
	% I: nume - fisierul cu imaginea de prelucrat, 
    %    filtru - fisier text care contine matricea filtru 
    
    % E: -
    
    % Exemple de apel:
    % filtrare_medie('vulpea si marmota.jpg','m9','png');
    % parametrul filtru poate fi (din exemplele atasate):
    %       - pentru filtrare medie: m3, m5 sau m9 
    
    % incarcare imagine
    poza=imread(nume);
    [m,n,p]=size(poza);
    
    %incarcare filtru medie si aplicarea mediei
    nf=[filtru '.txt'];
    w=load(nf);
    suma=sum(sum(w)); 
    w=w/suma;
    
    % aplicare filtru pe fiecare plan al imaginii
    R=zeros(m,n,p);
    for k=1:p
        R(:,:,k)=filtru_c(poza(:,:,k),w);
    end;
    R=uint8(R);
    
    rez = R;
end

function [ R ] = filtru_c( I, w )
    % aplicarea filtrului de tip corelatie pe o imagine (un plan)
    % I: I - imaginea initiala (un plan)
    %    w - filtrul aplicat (matrice patrata, dimensiuni impare)
    % E: R - imaginea filtrata
    
    % pentru operatia de corelatie se poate folosi functia MatLab filter2(w,f)
    % pentru operatia de convolutie se poate folosi functia MatLab conv2
    
    [m,n]=size(I);
    [m1,n1]=size(w);
   
    a=(m1-1)/2; b=(n1-1)/2;
    l=m+2*a; c=n+2*b;
    
    f=zeros(l,c);
   
    f(a+1:m+a,b+1:n+b)=double(I);
    R=zeros(m,n);
       
    % filtrare cu masca w
    for i=1:m
        for j=1:n
            for s=-a:a
                for t=-b:b
                    R(i,j)=R(i,j)+w(1+a+s,1+b+t)*f(i+a+s,j+b+t);
                end;
            end;
        end;
    end;
end



