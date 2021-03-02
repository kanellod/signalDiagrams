clear all 
close all

START = 100;
STEP  = 1; %us
END   = 5000;    %us
DUTY_CYCLE_50 = 2500;
HIGH = 1;
LOW  = 0;
NUMBER_OF_SIGNALS_PLOTTING = 8;
DEAD_TIME = 70;
IOM_DEBOUNCE_TIME_DELAY = 50;
THRESHOLD_FOR_EVENT_COUNTER = 220/5000;
THR = 220;

TIME = -START:STEP:END;

%limits
Phase_TOP_FET_1_ON  = DEAD_TIME+START;
Phase_TOP_FET_1_OFF = DUTY_CYCLE_50+START;
Phase_BOTTOM_FET_1_ON  = START;
Phase_BOTTOM_FET_1_OFF = DUTY_CYCLE_50+START+DEAD_TIME;
PhaseFeedback1_ON  = DEAD_TIME+START; 
PhaseFeedback1_OFF = DUTY_CYCLE_50+START;
GTM_GEN_REFERENCE_PHASE_1_ON  = Phase_BOTTOM_FET_1_ON+IOM_DEBOUNCE_TIME_DELAY;
GTM_GEN_REFERENCE_PHASE_1_OFF = PhaseFeedback1_OFF+IOM_DEBOUNCE_TIME_DELAY;
COUNTER_RESET1 = PhaseFeedback1_ON;
COUNTER_RESET2 = PhaseFeedback1_OFF;
% end limits

% calculation
Phase_TOP_FET_1 = zeros(1,length(TIME));
Phase_TOP_FET_1((Phase_TOP_FET_1_ON):(Phase_TOP_FET_1_OFF)) = HIGH;

Phase_BOTTOM_FET_1 = ones(1,length(TIME));
Phase_BOTTOM_FET_1(Phase_BOTTOM_FET_1_ON:Phase_BOTTOM_FET_1_OFF) = LOW;

PhaseFeedback1 = zeros(1,length(TIME));
PhaseFeedback1(PhaseFeedback1_ON:PhaseFeedback1_OFF) = 1;

GTM_GEN_REFERENCE_PHASE_1 = zeros(1, length(TIME));
GTM_GEN_REFERENCE_PHASE_1(GTM_GEN_REFERENCE_PHASE_1_ON:GTM_GEN_REFERENCE_PHASE_1_OFF) = 1;

MON_XOR_REF = zeros(1,length(TIME));
MON_XOR_REF = xor(PhaseFeedback1,GTM_GEN_REFERENCE_PHASE_1);

COUNTER = zeros(1, length(TIME));
ANGLE   = 1/(COUNTER_RESET2-COUNTER_RESET1);
for index=COUNTER_RESET1:1:COUNTER_RESET2
   COUNTER(index) = ANGLE*(index-COUNTER_RESET1); 
end
for index2=COUNTER_RESET2:1:COUNTER_RESET2+(COUNTER_RESET2-COUNTER_RESET1)
   COUNTER(index2) = ANGLE*(index2-COUNTER_RESET2); 
end
for index3=1:1:COUNTER_RESET1
   COUNTER(index3) = (ANGLE*(index3-(COUNTER_RESET1-COUNTER_RESET2))); 
end

THRESHOLD = zeros(1,length(TIME));
THRESHOLD = THRESHOLD + THRESHOLD_FOR_EVENT_COUNTER;

EVENT_WINDOW = zeros(1,length(TIME));
EVENT_WINDOW(START+THR:PhaseFeedback1_OFF) = 1;

ERROR_COUNTER = zeros(1,length(TIME));
ERROR_COUNTER = and(EVENT_WINDOW,MON_XOR_REF);
% end calculation

% plotting proccessing

Phase_TOP_FET_1           = Phase_TOP_FET_1           + 2*(NUMBER_OF_SIGNALS_PLOTTING);
Phase_BOTTOM_FET_1        = Phase_BOTTOM_FET_1        + 2*(NUMBER_OF_SIGNALS_PLOTTING-1);
PhaseFeedback1            = PhaseFeedback1            + 2*(NUMBER_OF_SIGNALS_PLOTTING-2);
GTM_GEN_REFERENCE_PHASE_1 = GTM_GEN_REFERENCE_PHASE_1 + 2*(NUMBER_OF_SIGNALS_PLOTTING-3);
MON_XOR_REF               = MON_XOR_REF               + 2*(NUMBER_OF_SIGNALS_PLOTTING-4);
COUNTER                   = COUNTER                   + 2*(NUMBER_OF_SIGNALS_PLOTTING-5);
THRESHOLD                 = THRESHOLD                 + 2*(NUMBER_OF_SIGNALS_PLOTTING-5);
EVENT_WINDOW              = EVENT_WINDOW              + 2*(NUMBER_OF_SIGNALS_PLOTTING-6);
ERROR_COUNTER             = ERROR_COUNTER             + 2*(NUMBER_OF_SIGNALS_PLOTTING-7);
% end plotting proccessing

figure(1)
hold on
%axis equal
grid on
plot(TIME,PhaseFeedback1,'r')
plot(TIME,Phase_TOP_FET_1,'g')
plot(TIME,Phase_BOTTOM_FET_1,'b')
plot(TIME,GTM_GEN_REFERENCE_PHASE_1,'r')
plot(TIME,MON_XOR_REF,'g')
plot(TIME,COUNTER,'b')
plot(TIME,THRESHOLD,'r')
plot(TIME,EVENT_WINDOW,'g')
plot(TIME,ERROR_COUNTER,'b')

legend('Phase_TOP_FET_1','Phase_BOTTOM_FET_1','PhaseFeedback1','GTM_GEN_REFERENCE_PHASE_1','MON_XOR_REF','COUNTER','THRESHOLD','EVENT_WINDOW','ERROR_COUNTER');
title('IOM functionality');
xlabel('cycle 0-5000');
ylabel('digital output');
axis([-100 5000 -0.5 NUMBER_OF_SIGNALS_PLOTTING*2+1.5])

% frame and cycle tasks
clear all

START = -200;
STEP  = 0.01;
END   = 60200;
TIME  = START:STEP:END;

DC_50 = 2430/5000;

height_of_diagram = 10.0;

basic_pulse = (1/2)*square(2*pi*TIME,DC_50)+randn(size(TIME))/10;

figure(2)
hold on
grid on

rectangle('Position', [0     0    20000 height_of_diagram]) % frame 1
rectangle('Position', [0     0    5000 height_of_diagram])  % cycle 1
rectangle('Position', [5000  0    5000 height_of_diagram])  % cycle 2
rectangle('Position', [10000 0    5000 height_of_diagram])  % cycle 3
rectangle('Position', [15000 0    5000 height_of_diagram])  % cycle 4
rectangle('Position', [20000 0    20000 height_of_diagram]) % frame 2
rectangle('Position', [20000 0    5000 height_of_diagram])  % cycle 1
rectangle('Position', [25000 0    5000 height_of_diagram])  % cycle 2
rectangle('Position', [30000 0    5000 height_of_diagram])  % cycle 3
rectangle('Position', [35000 0    5000 height_of_diagram])  % cycle 4
rectangle('Position', [40000 0    20000 height_of_diagram]) % frame 3
rectangle('Position', [40000 0    5000 height_of_diagram])  % cycle 1
rectangle('Position', [45000 0    5000 height_of_diagram])  % cycle 2
rectangle('Position', [50000 0    5000 height_of_diagram])  % cycle 3
rectangle('Position', [55000 0    5000 height_of_diagram])  % cycle 4

rectangle('Position', [-200  1    200  0.4],'FaceColor',[1 0 0]) % bottom FET before cycle1
rectangle('Position', [2570  1    2430 0.4],'FaceColor',[1 0 0]) % bottom FET cycle 1
rectangle('Position', [70    1.5  2430 0.4],'FaceColor',[1 0 0]) % top FET
rectangle('Position', [7570  1    2430 0.4],'FaceColor',[1 0 0])
rectangle('Position', [5070  1.5  2430 0.4],'FaceColor',[1 0 0])
rectangle('Position', [12570 1    2430 0.4],'FaceColor',[1 0 0])
rectangle('Position', [10070 1.5  2430 0.4],'FaceColor',[1 0 0])
rectangle('Position', [17570 1    2430 0.4],'FaceColor',[1 0 0])
rectangle('Position', [15070 1.5  2430 0.4],'FaceColor',[1 0 0])

line([0 0],[],'color','b')

axis([-200 60200 -0.5 10.5])
