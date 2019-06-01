%
% Simple Genetic Algorithm Rev. 1
% 
% Author: Novin Shahroudi
% Website: http://novinshahroudi.ir
% Date: May 11, 2015 @ 17:00 - 23:50
% 

clear;
clc;

close all;

% GA settings -------------------------
numOfGenes = 40;
numOfChromosomes = 100;      % equals the population in each generation
numOfElites = 5;           % shouldn't exceeds total num of chromosomes
crossOverRate = 0.5;        % cross over rate
crossOverFraction = 0.4;    % its share in next generation's diversity
lowerBound = -3;            % lower bound
upperBound = 3;             % upper bound
numOfGenerations = 150;
% -------------------------------------

%  create initial population

population = zeros(numOfChromosomes, numOfGenes);

% generate random chromosomes
for chrome=1:numOfChromosomes
    % random number r between a and b bounds
    population(chrome, 1:numOfGenes) = lowerBound + (upperBound-lowerBound).*rand(1, numOfGenes);
end

% display([max(r) min(r)])

bestFitnesses = zeros(1:numOfGenerations, 1);

figure('Name', ''), hold on;

% generations living beat
for generation=1:numOfGenerations
    newPopulation = zeros(numOfChromosomes, numOfGenes);
    
    fitness = zeros(size(population, 1), 1);
    
    selectionIdx = 0;
    % selection elite --------------------
    for i=1:size(population, 1)
        fitness(i, 1) = objFunc(population(i, :));
    end
    
    [m mi] = sort(fitness);
    
    bestFitnesses(generation) = min(fitness);
    
    plot(bestFitnesses, 'LineWidth', 2);
    xlabel('Generations')
    ylabel('Fitness Value')
    title(['current generation fitness = ', num2str(bestFitnesses(generation))]);
    xlim([1 numOfGenerations])
    pause(0.01)
    
    elite = population(mi(1:numOfElites), :);     % best <numOfElites> children
    
    for k=1:size(elite, 1)
        selectionIdx = selectionIdx + 1;
        newPopulation(selectionIdx, :) = elite(k, :);
    end
    
    % cross over -------------------------
    for i=1:floor(((numOfChromosomes - numOfElites) * crossOverFraction)/2)
        %         disp(['parent ', num2str(i), ':']);
        
        parentA = population(randi([1,numOfChromosomes]), :);
        parentB = population(randi([1,numOfChromosomes]), :);
        
        a = parentA + parentB;
        
        childA = parentA;
        childB = parentB;
        childB(1, numOfGenes*crossOverRate:numOfGenes) = parentA(1, numOfGenes*crossOverRate:numOfGenes);
        
        childA(1, numOfGenes*crossOverRate:numOfGenes) = parentB(1, numOfGenes*crossOverRate:numOfGenes);
        
        b = childA + childB;
        %           test whether mutation is performed right
        %         a-b
        %         display(i);
        
        selectionIdx = selectionIdx + 1;
        newPopulation(selectionIdx, :) = childA;
        selectionIdx = selectionIdx + 1;
        newPopulation(selectionIdx, :) = childB;
    end
    
    %     newPopulation
    %     display(selectionIdx)
    
    % mutation ---------------------------
    for i=1:ceil((numOfChromosomes - numOfElites) * (1 - crossOverFraction))
        mutantCandidate = population(randi([1,numOfChromosomes]), :);
        
        mutantCandidate(1, 1:numOfGenes) = lowerBound + (upperBound-lowerBound).*rand(1, numOfGenes);
        
        selectionIdx = selectionIdx + 1;
        newPopulation(selectionIdx, :) = mutantCandidate;
        
        %         display(i);
    end
    
    % next generation --------------------
    population = newPopulation;
    
end