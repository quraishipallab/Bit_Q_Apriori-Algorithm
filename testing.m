%% 
clc;
clear;

n=10;  %number of transactions

%read excel file to get data

[~,gender] = xlsread('Bit_Q.xlsx', 'B2:B11');
blood_sugar = xlsread('Bit_Q.xlsx', 'C2:C11')';
[~, blood_type] = xlsread('Bit_Q.xlsx', 'D2:D11');


%find out the transactions where certain attributes occured
k_man=find(contains(gender,'Man'));
k_woman=find(contains(gender,'Woman'));
k_bs_low = find(blood_sugar<3.9);
k_bs_med = find(blood_sugar>=3.9 & blood_sugar<=6.1);
k_bs_high = find(blood_sugar>6.1);
k_bt_A=find(contains(blood_type,'A')&~contains(blood_type,'B'));
k_bt_B=find(contains(blood_type,'B')&~contains(blood_type,'A'));
k_bt_O=find(contains(blood_type,'O'));
k_bt_AB=find(contains(blood_type,'AB'));

Bs = cell(1,9);
%calculate the bitset of the attributes using the Bit_set funtion
bitset_man=Bit_set(k_man,n);
bitset_woman=Bit_set(k_woman,n);

bitset_bs_low=Bit_set(k_bs_low,n);
bitset_bs_med=Bit_set(k_bs_med,n);
bitset_bs_high=Bit_set(k_bs_high,n);

bitset_bt_A=Bit_set(k_bt_A,n);
bitset_bt_B=Bit_set(k_bt_B,n);
bitset_bt_O=Bit_set(k_bt_O,n);
bitset_bt_AB=Bit_set(k_bt_AB,n);

Bs = {bitset_woman; bitset_man; bitset_bs_low;bitset_bs_med;bitset_bs_high;bitset_bt_A;bitset_bt_B;bitset_bt_O;bitset_bt_AB};
Bb = {'0100000';'1000000';'0001000';'0010000';'0011000';'0000001';'0000010';'0000011';'0000100'};
%calculate the binary bits of the attribute

% Create Items Set
    count=2;
% 1st Level Frequent Patterns
    
    for i=1:numel(Bs)
        Count(i)=OneCount(Bs{i});
    end
    m=1;
    for i=1:numel(Count)
        if Count(i)>=count
        L{1}{m} = Bs{i};  % generate 1 frequent bitset
        P{1}{m} = Bb{i};  % generate 1 frequent binary bits
        m=m+1;
        end
    end    
 k=2;
 while numel(L{k-1})>1
    p=0; 
    Ck=[];
    for i=1:numel(L{k-1})
         for j=1:numel(L{k-1})
             p=p+1;
             if i==j
                 C{k}{p}=0;
                 CB{k}{p}=0;
             else
             C{k}{p}=(bitand(bin2dec(L{k-1}(j)), bin2dec(L{k-1}(i))));
             CB{k}{p}=(bitor(bin2dec(P{k-1}(j)), bin2dec(P{k-1}(i))));
             end
         end 
    end

     Ck = (cell2mat(C{k}));
     CBk =(cell2mat(CB{k}));
     for i=1:length(Ck)
         merged{k}{i,1}=[Ck(i) CBk(i)];
     end
x1 = cellfun(@(y)y(:)', merged{k}, 'UniformOutput',0);
x2 = cell2mat(x1);
x3 = unique(x2,'rows');
x4 = num2cell(x3,1);
Ck=x4{1};
CBk=x4{2};

    
 m=1;
     flag=0;
     for r=1:length(Ck)
         if OneCount(dec2bin(Ck(r),n))>=count
             L{k}{m}=dec2bin(Ck(r),n);
             P{k}{m}=dec2bin(CBk(r),7);
             m=m+1;
             flag=1;
         end      
     end
   
    k=k+1;
end 
disp(L{k-1})
disp(P{k-1})
    