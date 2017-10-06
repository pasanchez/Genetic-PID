%% Init
clear
clc
close all
%% params
population_size = 100;
population_to_keep = 30;

%% System
TF = tf([ 1 2],[1 2 1]);

%% initial population

for i=1:population_size
    population(i) = Pid_Agent(TF);
end

%% loop

f = figure;
z = 1;
while true
    % simulate population & create mating pool
    best_score = 0;
    k = 1;
    for i=1:population_size
        score = population(i).getScore();
        if score > best_score
            best = population(i);
        end
        for j=1:round(score*100)
            mating_pool(k) = population(i);
            k = k +1;
        end
    end
    % show best response
    fprintf('Kp: %f Ki: %f Kd: %f. O: %f ST: %f\n',best.genome(1),best.genome(2),best.genome(3), ...
        best.info.Overshoot,best.info.SettlingTime);
    subplot(1,2,1)
    step(best.sys);
    best_points(z) = best.score;
    z = z +1;
    subplot(1,2,2)
    plot(best_points);
    title('Max score in each generation.');
    pause(0.01);
    % keep some agents from old population
    for i=1:population_to_keep
        population(i) = mating_pool(floor(rand()*(k-1)+1));
    end
    % mate
    for p=population_to_keep+1:population_size
        index_a = floor(rand()*(k-1)+1);
        index_b = floor(rand()*(k-1)+1);
        population(p) = mating_pool(index_a).mate(mating_pool(index_b));
    end
end