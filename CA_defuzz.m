%_____________________________________________________________________%
    % ------------  Creator    :      Ali Rezaei         ----------- %
    % ------------  K. N. Toosi University of Technology ----------- % 
    % ------------      Advanced Control Systems Lab     ----------- %
    % ------------   Email: a.rezaei2@email.kntu.ac.ir   ----------- %
    %                   Center Average Defuzzifier                   %
%_____________________________________________________________________%

%  Custom defuzzification functions must be of the form
%     y = customdefuzz(x,ymf), where x is the vector of 
% values in the membership function input range and ymf 
% contains the values of the membership function for each x value.


% It is better if the output MFs are not overlapped.

function out= CA_defuzz(x,ymf)
    x=reshape(x,1,[]);
    ymf=reshape(ymf,1,[]);
    loc_x = islocalmax(ymf);
    loc_x(1)=1;
    loc_x(end)=1;
    xx=x(loc_x);
    w=ymf(loc_x);
    out=(w*(xx'))/sum(w,"all");
end

% ____________________ End of the program. _______________________ % 
