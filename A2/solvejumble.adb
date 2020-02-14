-- Assignment 2 - CIS3190 
--
-- Author: Loui Zibdawi
--
-- Asks user for input and finds all anagrams of that input that are 
-- present in the Canadian Dictionary Small
--
with ada.text_IO; use Ada.text_IO;
with Ada.text_IO, Ada.Containers.Ordered_Sets;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with Ada.strings.Fixed; use Ada.Strings.Fixed;
procedure solveJumble is
    -- Array of unbounded strings used to hold all anagrams
    type strArray is array(Integer range <>) of unbounded_string;
    -- Ordered set used to hold all dictionary words
    package CS is new Ada.Containers.Ordered_Sets(unbounded_string); use CS;

    dict : set;
    size, numWords : integer;
    input : strArray(0 .. 200);

    -- inputJumble
    -- Gets the users input and checks if it is valid
    -- 
    -- Return: Users inputted String
    --
    procedure inputJumble(userInput : in out strArray; numWords : in out integer) is
        index : integer := 1;
        s : unbounded_string;
    begin
        -- Get user input
        put_line("Enter one or more word jumbles(End by clicking enter on a blank line): ");
        loop
            get_line(s);
            -- Exit if the input is blank
            exit when Index_Non_Blank(s) = 0;
            userInput(index) := s;
            index := index + 1;
        end loop;
            -- Number of words will always be one less than the index at the end
            numWords := index - 1;
    end inputJumble;

    -- generateAnagrams
    -- Gets the users input and checks for valid input
    --
    -- Parameters
    --      str - User inputted string that will be the base of all anagrams found
    --      size - Amount of possible anagrams. (Length factorial)
    -- Return: Users inputted String
    --
    function generateAnagrams(str: in out unbounded_string; size : integer) return strArray is
        anagrams : strArray(0 .. size);
        count : integer := 1;

        -- permute
        -- Finds all permutations of a string
        -- 
        -- In:
        --      str - String to be permutated
        --      index - current index
        -- Out:
        --      str - String to be permutated
        --
        procedure permute(str: in out unbounded_string; index: in integer) is
            -- arrayContains
            -- Checks if a string is already in the array
            -- 
            -- Parameters
            --      arr - Array to be checked. In this case it is all the current anagrams
            --      size - Amount of anagrams currently in array
            --      str - Anagram that is being checked
            -- Return: True if the array contains the string and false if not
            --
            function arrayContains(arr : strArray ; size : integer; str : unbounded_string) return boolean is 
                found : boolean := false;
            begin  
                for i in 1 .. size loop
                    if arr(i) = str then
                        found := true;
                        exit;
                    end if;
                end loop;

                return found;
            end arrayContains;

            -- swap
            -- Swaps characters at two index positions in an unbounded string
            -- 
            -- In:
            --      str - String to be changed
            --      i - Index #1
            --      j - Index #2
            -- Out:
            --      str - String to be changed
            --
            procedure swap(str: in out unbounded_string; i: in integer; j: in integer) is
                temp: character;
                tempString : string := To_String(str);
            begin
                temp := tempString(i);
                tempString(i) := tempString(j);
                tempString(j) := temp;

                str := To_Unbounded_String(tempString);
            end swap;

        begin
            if(index = length(str)) then
                -- If the anagram is not already in the set then add
                if arrayContains(anagrams, count, str) = false then
                    anagrams(count) := str;
                    count := count + 1;
                end if;
            else 
                for i in index .. length(str) loop
                    swap(str, index, i);
                    permute(str, index+1);
                    swap(str, index, i);
                end loop;
            end if;
        end permute;

    begin
        permute(str, 1);
        return anagrams;
    end generateAnagrams;

    -- factorial
    -- Finds the factorial of a given integer using recursion
    -- 
    -- Paramaters:
    --      num - Number for which the factorial is found
    -- Return
    --      result - factorial of orginial input
    --
    function factorial(num : integer) return integer is
        result : integer := 1;
    begin
        if num > 1 then
            result := num * factorial(num - 1);
        end if;
        return result;
    end factorial;

    -- buildLEXICON
    -- Builds dictionary from local dictionary /usr/share/dict/canadian-english-small
    -- and stores it in a ordered set
    -- 
    -- Return
    --      result - Ordered set containing all the words in the dictionary given
    --
    function buildLEXICON return Set is
        s : unbounded_string;
        infp : file_type;
        result : Set;
    begin
        open(infp,in_file,"/usr/share/dict/canadian-english-small"); 
        -- Loop through each line of the dictionary and add to the set
        loop
            exit when end_of_file(infp);
            get_line(infp,s);
            result.insert(s);
        end loop;
        close(infp);

        return result;
    end buildLEXICON;

    -- findAnagram
    -- Searches the dictionary for anagrams of a string and prints out all matches
    -- 
    -- In:
    --      anagram - Array of strings of all possible anagrams of the users input
    --      size - Max amount of anagrams from user input (Length factorial)
    --      dict - Ordered set of all the words in the dictionary   
    --
    procedure findAnagram(anagram : in strArray; size : in integer; dict : in set) is
        found : integer := 0;
    begin
        -- Loop through all anagrams in set and look for them in the dictionary.
        for i in 1 .. size loop
            -- If found then print to screen
            if contains(dict, anagram(i)) then
                put(anagram(i) & " ");
                found := found + 1;
            end if;
        end loop;

        if found = 0 then
            put_line(" ( No anagram found ) ");
        else
            put_line("(" & integer'image(found) & " anagram(s) were found )");
        end if;

    end findAnagram;

begin
    put_line("---------------------------------");
    put_line("     Welcome To Word Jumble");
    put_line("---------------------------------");
    -- Reading in dictionary
    dict := buildLEXICON;
    
    numWords := 0;
    loop
        --Get user input
        inputJumble(input, numWords);
        --Get factorial
        put_line("------------------------------------------");
        for i in 1 .. numWords loop
            size := factorial(length(input(i)));
            put(input(i) & " - ");
            -- Generate all possible and unique anagrams
            declare
                anagrams: strArray := generateAnagrams(input(i), size);
            begin
                --Find valid anagrams in dictionary
                findAnagram(anagrams, size, dict);
            end;
        end loop;
        put_line("------------------------------------------");
        new_line;
    end loop;
end solveJumble;