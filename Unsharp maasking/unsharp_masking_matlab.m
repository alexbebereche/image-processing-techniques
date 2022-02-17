function [] = unsharp_masking_matlab(nume, alpha)
% I: nume, alpha
% exemplu apel: unsharp_masking_matlab('vulpea si marmota.jpg', 0.2);

I=imread(nume);
figure
imshow(I);
title('Imaginea originala');

h = fspecial('unsharp', alpha);
rez=imfilter(I,h);
figure
imshow(rez);
title(['Filtru tip unsharp cu alpha=' num2str(alpha)]);

end