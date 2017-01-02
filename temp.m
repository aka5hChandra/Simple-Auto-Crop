function temp(f)
global erm;
close all;
%f = imadjust(f,[.2 .3 0; .6 .7 1],[]);

tresh = 150;%190;
r = f(: , : , 1) ;
g = f(: , : , 2) ;
b = f(: , : , 3) ;
%{
r = imadjust( r , [0 , .5] , [0 , .1]);
g = imadjust( g , [0 , .5] , [0 , .1]);
b = imadjust( b , [0 , .5] , [0 , .1]);
%}

hr = imhist(r);
hg = imhist(g);
hb = imhist(b);

[m tr] = max(hr);
[m tg] = max(hg);
[m tb] = max(hb);
s = 10;

r = (r >= tresh);

figure ; imshow(r) ; title('r');
g = (g >= tresh );

figure ; imshow(g) ; title('g');
b = (b >= tresh);

figure ; imshow(b) ; title('b');

o = r & g & b ;
figure ; imshow(o) ; title('final');


sz = size(o);
oriMid = uint32(sz ./ 2);
midX = oriMid;
%left = o(1 : mid(1) , 1 : mid(2));
%right = o(mid(1) + 1 : sz(1) , mid(2) + 1 : sz(2));
preMidX = midX;
%find top left corner
value = o(midX(1) , midX(2));
%mid x
while(value == 1 && midX(1) > 1 )
    preMidX = midX;
    midX(1) = uint32(midX(1) ./2);
    value =  orLogic(o , midX(1) , midX(2) , 1 );
    %o(midX(1) , midX(2) ) | o(midX(1)+ 1 , midX(2) + 1 ) | o(midX(1) -1  , midX(2) -1 );
end;

midY = preMidX;
preMidY = midY;
value = o(midY(1) , midY(2));
while(value == 1 && midY(2) > 1 )
    preMidY = midY;
    midY(2) = uint32(midY(2) ./2);
    value =orLogic(o , midY(1) , midY(2) , 2 );
end;
global er;

leftAnchor = [preMidY(1) , preMidY(2)];
value = orLogic( o , leftAnchor(1) , leftAnchor(2)  , 1);
while( value ~= 0 && leftAnchor(1) > 1)
 leftAnchor(1) = leftAnchor(1) - 1;
 value = orLogic( o , leftAnchor(1) , leftAnchor(2) , 1);
end;
leftAnchor(1) = leftAnchor(1) + erm; %uint32(erm); % erorr correctn
value = orLogic( o , leftAnchor(1) , leftAnchor(2) , 2);
while(value ~= 0 && leftAnchor(2) > 1)
 leftAnchor(2) = leftAnchor(2) - 1;
 value = orLogic( o , leftAnchor(1) , leftAnchor(2) , 2);
end;
%leftAnchor(1) = leftAnchor(1) - erm; %;uint32(erm); % erorr correctn

%leftAnchor(2) = leftAnchor(2) - er;
%leftAnchor(1) = leftAnchor(1) - er;
hold on;
plot(leftAnchor(2) ,leftAnchor(1) ,'r.','MarkerSize',20)




%%%%rght bottom


midX = oriMid;
%left = o(1 : mid(1) , 1 : mid(2));
%right = o(mid(1) + 1 : sz(1) , mid(2) + 1 : sz(2));
preMidX = midX;
%find top left corner
value = o(midX(1) , midX(2));
%mid x
while(value == 1 && midX(1) < sz(1)  )
    preMidX = midX;
    midX(1) = uint32((sz(1) + midX(1)) ./2);
    value =  orLogic(o , midX(1) , midX(2) , 1 );
    %o(midX(1) , midX(2) ) | o(midX(1)+ 1 , midX(2) + 1 ) | o(midX(1) -1  , midX(2) -1 );
end;

midY = preMidX;
preMidY = midY;
value = o(midY(1) , midY(2));
while(value == 1 && midY(2) < sz(2) )
    preMidY = midY;
    midY(2) = uint32((sz(2) + midY(2)) ./2);
    value =orLogic(o , midY(1) , midY(2) , 2 );
end;


rightAnchor = [preMidY(1) , preMidY(2)];
value = orLogic( o , rightAnchor(1) , rightAnchor(2)  , 1);
while( value ~= 0 && rightAnchor(1) < sz(1))
 rightAnchor(1) = rightAnchor(1) +1;
 value = orLogic( o , rightAnchor(1) , rightAnchor(2) , 1);
end;
rightAnchor(1) = rightAnchor(1) - erm; %uint32(erm); % erorr correctn
value = orLogic( o , rightAnchor(1) , rightAnchor(2) , 2);
while(value ~= 0 && rightAnchor(2) < sz(2))
 rightAnchor(2) = rightAnchor(2) + 1;
 value = orLogic( o , rightAnchor(1) , rightAnchor(2) , 2);
end;
%rightAnchor(1) = rightAnchor(1) - erm; %;uint32(erm); % erorr correctn

%rightAnchor(2) = rightAnchor(2) - er;
%rightAnchor(1) = rightAnchor(1) - er;
hold on;
plot(rightAnchor(2) ,rightAnchor(1) ,'r.','MarkerSize',20)

end

function value = orLogic(im , x , y , c )
global er;
er = 51;
global erm;
erm = uint32(floor( er / 2));
%{
    switch(c)
        case 1 %chec left
        value = im(x , y) | im(x - er , y  );
        case 2 %chec top;
        value = im(x , y) | im(x  , y - er );
    end;
%}
  sz = size(im);
if((x - erm < 1 || y - erm < 1 )|| (x + erm > sz(1) || y + erm > sz(2)) )
    value = im(x , y); return;
else
randW = ones( er , er) ;%uint8(rand(er));
imW = im( x - erm : x + erm , y - erm : y + erm);

value = sum(sum(randW & imW));%/ er ;
if(value > 0) value = 1;
else
    value = 0;
end;
end;

end

