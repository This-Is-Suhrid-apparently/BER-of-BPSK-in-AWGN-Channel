%BER of BASK under AWGN Channel

%% Input Bits Generation
N=10000000; %Input Size
m=randi([0 1],1,N); % Random N bits generation : 1 or 0

%% Unipolar Mapping
for i=1:N
    if m(i)==0
       x(i)=0;
    else 
        x(i)=1;
    end
end


ber_sim=[];%Practical BER
ber_theory=[]; %Theoretical BER in terms of erfc
ber_theory_2=[]; %Theoretical BER in terms of Q-function
ber_chernoff=[];

for Eb_No_dB=0:1:15; % Eb/No value in dB i.e the SNR value [Check time 12:30]
                     % For loop for a range of SNRs
    Eb_No=10^(Eb_No_dB/10) % Eb/No value

    %The expression for SNR of BASK and BPSK is SNR= Eb/(No/2). For BFSK
    %instead of No/2, it will be No. Now No/2 is the Noise Power which can also
    %be represented by (sigma)^2 i.e the variance of noise. Now SNR can be
    %varied by keeping either the numerator or the denominator fixed and
    %varying the other. In this case we keep the Signal power unity i.e Eb=1
    %and vary the noise power to bring variation in SNR.
    %Therefore, SNR= Eb/(No/2)= 1/(sigma)^2. Hence sigma=sqrt(1/(2Eb/No)).
    %sigmna is the Standard Deviation.

    %Now, randn= mean + (S.D)*randn(1,N) generates a 1xN matrix of Gaussian or
    %Normally distributed Random Numbers. Therefore now, we can vary the value
    %of Eb/No to get Gaussian distributed Random numbers with different variance 
    %i.e different noise powers and therefore different values of SNR


    %% AWGN output
    sigma=sqrt(1/(2*Eb_No));
    r= x+sigma.*randn(1,N); %Output of the AWGN Channel. x is the Signal and the rest is Noise.

    %% Decision Devise Output
    m_cap=(r>0.5);

    %% BER Calculation
    no_of_errors=sum(m~= m_cap);  %total number of errors     
    
    ber_sim1= no_of_errors/N;
    ber_sim=[ber_sim ber_sim1];
    
    ber_theory_erfc= 0.5*erfc(sqrt(Eb_No/4));
    ber_theory=[ber_theory  ber_theory_erfc];
    
    % Q-function and erfc are related
    % Q(x)=0.5*erfc(x/sqrt(2))
    % Lets simulate by Q-function also
    
    ber_theory_q= qfunc(sqrt(Eb_No/2));
    ber_theory_2=[ber_theory_2 ber_theory_q];
    
    %Chernoff Bound: The highest BER that can be achieved i.e the upper
    %bound for BER. It is given from Q(x)<= 0.5*exp(-(x^2)/2).
    %So BER of BASK<= 0.5*exp(-Eb/4No).This the max value above which BER
    %can't go
    
    ber_approx= 0.5*exp(-Eb_No/4);
    ber_chernoff=[ber_chernoff ber_approx];
    
end

%% BER Plot Practically and Theoretically 
Eb_No_dB=0:1:15;
%semilogy(Eb_No_dB, ber_sim,'r*-'); 
semilogy(Eb_No_dB, ber_sim,'r*-',Eb_No_dB, ber_theory ,'ko-',Eb_No_dB, ber_theory_2 ,'g+-',Eb_No_dB,  ber_chernoff ,'m>-'); 
xlabel('Eb/No(in dB)'); ylabel('BER');
legend('Simulated BER','Theoretical BER(in erfc)','Theoretical BER(in Q-function)','Chernoff Bound');
grid on;


% semilogy(Y) creates a plot using a base 10 logarithmic scale for the y-axis and a
% linear scale for the x-axis.
% It plots the columns of Y versus their index. If Y contains complex values,
% then semilogy(Y) is equivalent to semilogy(real(Y),imag(Y)).
% The semilogy function ignores the imaginary component in all other uses of this function.
% 
% semilogy(X1,Y1,...) plots all Yn versus Xn pairs. If only one of Xn or Yn is a matrix, 
% semilogy plots the vector argument versus the rows or columns of the matrix,
% along the dimension of the matrix whose length matches the length of the vector.
% If the matrix is square, its columns plot against the vector if their lengths match. 
% The values in Xn can be numeric, datetime, duration, or categorical values.
% The values in Yn must be numeric.
















