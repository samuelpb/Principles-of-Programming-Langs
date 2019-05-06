import Debug.Trace
import Data.List


{--

getFirst: gets the first element of a list using head, but checks if the list is empty

getLetters: takes in a number, and the length of a list, and returns every nth letter

getElements : gets every nth letter for all n numbers up to the length of the list

skips: calls the helper functions, starts with n = 1

--}

getFirst :: [a] -> [a]
getFirst [] = []
getFirst xs = head xs : []

getLetters :: Int -> Int -> [a] -> [a]
getLetters _ _ [] = []
getLetters n len xs
    | n>len = []
    | otherwise = getFirst (drop (n-1) xs) ++ getLetters n (len-n) (drop n xs)


getElements :: Int -> Int ->[a] -> [[a]]
getElements n len xs
    | n <= len = getLetters n len xs : getElements (n+1) len xs
    | otherwise = getLetters n len [xs]


skips :: [a] -> [[a]]
skips [] = [[]]
skips xs = getElements 1 (length xs) xs




{--

	if the list has three or more elements, will check for a local maxima and then check the rest of the lsit

	if it has less than three, there can't be a maxima and returns []

--}





localMaxima :: [Integer] -> [Integer]
localMaxima (a:b:c:xs)
    | (a<b) && (b>c) = b : localMaxima (c : xs)
    | otherwise = localMaxima (b : c : xs)
localMaxima _ = []


{--

check: takes in 9 and a list of integers, and returns a string representation of the integers there, with 
	an * to mark each one there

line: splits a list of groups of integers into rows:
		ex: [[1, 1, 1], [2, 2], [3], [4, 4, 4, 4]] --> [[1, 2, 3, 4], [1, 2, 4], [1, 4], [4]]
		--these are sent to check

build: maps check to line, and returns all the strings combined

histogram: sorts and groups the input, then sends it to build to be transformed into a string
	then formats the output



--}

check :: Integer -> [Integer] -> String
check x xs
    |x<0 = "\n"
    |elem x xs = check (x-1) xs ++ "*"
    |otherwise = check (x-1) xs ++ " "



line :: [[Integer]] -> [[Integer]]
line[[]] = []
line xs 
    |and (map null xs) = []
    |otherwise =   line (map (drop 1) xs) ++ [concat (map (take 1) xs)]


build :: [[Integer]] -> String
build xs = concat (map (check 9) (line xs))




histogram :: [Integer] -> String
histogram [] = "\n==========\n0123456789\n"
histogram xs = build (group (sort xs)) ++ "\n==========\n0123456789\n"



main = putStr(histogram [1,4,5,4,6,6,3,4,2,4,9] )


