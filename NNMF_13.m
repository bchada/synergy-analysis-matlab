% % %% NNMF analysis of participant 13 data from sEMG channels 1-8 %%
% % %% HRELab
% % %% Chad Berghoff

clear all, clear, clc

% Define number of activities and synergies
num_activities = 8;
num_synergies = 5; % Number of synergies to extract

% Define muscle labels (consistent across all files)
muscle_labels = {'BB', 'PD', 'AD', 'MD', 'TL', 'WF', 'WE', 'BR'};

% Preallocate cell arrays to store matrices
activity_data = cell(num_activities,1);
W_matrices = cell(num_activities,1);
H_matrices = cell(num_activities,1);
activity_names = cell(num_activities,1); % Store filenames for subplot titles

% Loop to import all activity files
for act = 1:num_activities
    filename = sprintf('processed-emg-%02d.csv', act); % Generate file name
    activity_names{act} = sprintf('Activity %d', act); % Store activity name
    temp_data = readmatrix(filename); % Read file
    temp_data(1, :) = []; % Remove first row (headers)
    
    % Extract the same muscle channels for each file
    BB = temp_data(:, 5); % Biceps Brachii
    PD = temp_data(:, 6); % Posterior Deltoid
    AD = temp_data(:, 7); % Anterior Deltoid
    MD = temp_data(:, 8); % Middle Deltoid
    TL = temp_data(:, 9); % Triceps Long-head
    WF = temp_data(:, 10); % Wrist Flexors
    WE = temp_data(:, 11); % Wrist Extensors
    BR = temp_data(:, 12); % Brachioradialis

    % Store cleaned matrix in cell array
    activity_data{act} = [BB, PD, AD, MD, TL, WF, WE, BR];

    % Perform NNMF on each activity
    opt = statset('MaxIter',10,'Display','final');
    [W0,H0] = nnmf(activity_data{act}, num_synergies, 'replicates', 5, 'options', opt, 'algorithm', 'mult');
    opt = statset('Maxiter',1000,'Display','final');
    [W,H] = nnmf(activity_data{act}, num_synergies, 'w0', W0, 'h0', H0, 'options', opt, 'algorithm', 'als');
    
    % Store NNMF results
    W_matrices{act} = W;
    H_matrices{act} = H;
end
filename

disp('All 8 activities imported and NNMF performed successfully.');

% Create a figure for subplots
figure;
tiledlayout(2,4, 'TileSpacing', 'compact', 'Padding', 'compact'); % 2 rows, 4 columns layout

% Loop to plot all 8 activities in subplots
for act = 1:num_activities
    nexttile; % Move to the next subplot
    b = bar(H_matrices{act}, 'grouped'); % Standard grouped bar chart for each activity
    
    xlabel('Synergies');
    ylabel('Activation Weight');
    title(activity_names{act}, 'FontSize', 12); % Set subplot title
    
    xticklabels({'Synergy 1', 'Synergy 2', 'Synergy 3', 'Synergy 4', 'Synergy 5'}); % Label each synergy
    xtickangle(45); % Rotate x-axis labels for better readability
    grid on;

    % **Adding category labels to each individual bar**
    [num_synergies, num_muscles] = size(H_matrices{act}); % Get number of synergies and muscles

    % Get bar positions
    for i = 1:num_synergies  % Loop over synergies
        for j = 1:num_muscles  % Loop over muscle contributions
            x = b(j).XEndPoints(i); % Get x-position of each bar
            y = b(j).YEndPoints(i); % Get y-position of each bar
            if H_matrices{act}(i, j) > 0  % Only label non-zero values
                text(x, y + 0.02 * max(H_matrices{act}(:)), muscle_labels{j}, ...  % Display muscle name
                    'HorizontalAlignment', 'center', ...
                    'VerticalAlignment', 'bottom', ...
                    'FontSize', 8, 'Color', 'k', 'FontWeight', 'bold');
            end
        end
    end
end

% Add a single legend for all subplots
legend(muscle_labels, 'Location', 'southoutside', 'Orientation', 'horizontal');

