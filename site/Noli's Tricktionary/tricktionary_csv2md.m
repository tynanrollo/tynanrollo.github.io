% Read Noli's Trictionary csv file and create a bunch of markdown files
% with the appropriate metadata and contents to integrate with Uni Bible
% Nakul Mohakar, 06/28/24

%%
filename = 'Tricktionary.csv';

% Read the entire CSV file into a table
fullTable = readtable(filename, 'NumHeaderLines',39, VariableNamingRule='preserve');
fullTable = renamevars(fullTable, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12"], ...
    ["Trick Name", "Alternate", "Categories", "Definition", "Invented By", "Year First", "Reference Video", "Timestamp", "Prereq", "Optional Prereq", "Entered By", "Notes"]);

% Change variables to character type
fullTable.("Trick Name") = char(fullTable.("Trick Name"));
fullTable.("Alternate") = char(fullTable.("Alternate"));
fullTable.("Categories") = char(fullTable.("Categories"));
fullTable.("Definition") = char(fullTable.("Definition"));
fullTable.("Invented By") = char(fullTable.("Invented By"));
fullTable.("Year First") = num2str(fullTable.("Year First"));
fullTable.("Reference Video") = char(fullTable.("Reference Video"));
fullTable.("Timestamp") = char(fullTable.("Timestamp"));
fullTable.("Prereq") = char(fullTable.("Prereq"));
fullTable.("Optional Prereq") = char(fullTable.("Optional Prereq"));
fullTable.("Entered By") = char(fullTable.("Entered By"));
fullTable.("Notes") = char(fullTable.("Notes"));

%%
table_length = size(fullTable);
table_length = table_length(1);
row = 1;
for row = 1:table_length
    % remove white spaces
    trick_name =    strtrim(fullTable{row,"Trick Name"});
    trick_name = erase(trick_name, "*");
    alternate =     strtrim(fullTable{row,"Alternate"});
    category =      strtrim(fullTable{row,"Categories"});
    definition =    strtrim(fullTable{row,"Definition"});
    invented_by =   strtrim(fullTable{row,"Invented By"});
    year =          strtrim(fullTable{row,"Year First"});
    ref_video =     strtrim(fullTable{row,"Reference Video"});
    timestamp =     strtrim(fullTable{row,"Timestamp"});
    entered_by =    strtrim(fullTable{row,"Entered By"});
    notes =         strtrim(fullTable{row,"Notes"});
    
    prereq = strtrim(strsplit(fullTable{row, "Prereq"}, ","));
    optional_prereq = strtrim(strsplit(fullTable{row, "Optional Prereq"}, ","));

    categories = strtrim(split(category, ","));
        
    % create and write to markdown (.md) file
        md_fileid = fopen(strcat(trick_name, '.md'), 'w');   % open file
        
        fprintf(md_fileid, '---\n');             % set up header info
        fprintf(md_fileid, 'alternate: ');
        fprintf(md_fileid, '%s\n', alternate);
        fprintf(md_fileid, 'category:\n');
        for i = 1:length(categories)
            fprintf(md_fileid, '%s\n', "  - "+ categories{i});
        end
        fprintf(md_fileid, 'tags:\n');
        for i = 1:length(categories)
            fprintf(md_fileid, '%s\n', "  - "+ categories{i});
        end
        fprintf(md_fileid, 'definition: ');
        fprintf(md_fileid, '%s\n', definition);
        fprintf(md_fileid, 'invented by: ');
        fprintf(md_fileid, '%s\n', invented_by);
        fprintf(md_fileid, 'year: ');
        fprintf(md_fileid, '%s\n', year);
        fprintf(md_fileid, 'video link: ');
        fprintf(md_fileid, '%s\n', ref_video);
        fprintf(md_fileid, 'entered by: ');
        fprintf(md_fileid, '%s\n', entered_by);
        fprintf(md_fileid, 'notes: ');
        fprintf(md_fileid, '%s\n', notes);
        
        fprintf(md_fileid, '---\n');             % end header
    
    % print alternate name
        fprintf(md_fileid, 'Alternate Name: '); 
        fprintf(md_fileid, '%s\n', alternate);
    % print inventor in italics
        if (invented_by == "")
            invented_by = "?";
        end
        if (year ~= "NaN")
            fprintf(md_fileid, '%s\n', "*Invented by "+ invented_by+  " in "+ year+ "*"); 
        else
            fprintf(md_fileid, '%s\n', "*Invented by "+ invented_by+  "*"); 
        end
    % print prereq tricks
        if prereq{1} ~= ""
            fprintf(md_fileid, '%s', "Prerequisite Tricks: [[" + prereq{1} + "]]");
            if length(prereq) > 1                   % print additional prereqs, comma separated
                for i = 2:length(prereq)
                    fprintf(md_fileid, '%s', ", [[" + prereq{i} + "]]");
                end
            end
            fprintf(md_fileid, '\n');
        end

    % print definition
        fprintf(md_fileid, '\n### Definition\n'); 
        fprintf(md_fileid, '%s\n', definition);
        % print video title with timestamp if included
        fprintf(md_fileid, '\n');
        if (ref_video ~= "")
            if (timestamp ~= "")
                fprintf(md_fileid, '%s\n', strcat('## Video Reference (', timestamp, ')'));   
            else
                fprintf(md_fileid, '## Video Reference\n');     
            end
        % embed video link
        fprintf(md_fileid, '%s\n', "![video](" + ref_video+ ")");
        end
    % print notes
        fprintf(md_fileid, '\n#### Notes:\n');
        fprintf(md_fileid, '%s\n', "- "+ notes);
    % print who entered it
        if(entered_by == "")
            entered_by = "?";
        end
        fprintf(md_fileid, '%s\n', "*entered by: "+ entered_by+ "*");
        
        fclose(md_fileid);                      % close file
end