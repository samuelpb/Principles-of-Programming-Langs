import Data.Graph.Inductive.Graph
import System.IO
import Data.Char
import Text.Read
import Data.List.Split
import Data.List
import Data.Maybe
import Data.Graph.Inductive.PatriciaTree
import Data.Graph
import Debug.Trace
import Text.Show
import Data.Ord



--Gets all the neighbors associated with a given node
lneighbors' :: Context a b -> Adj b
lneighbors' (p,_,_,s) = p ++ s

--Converts edges of the form [<vertexname>, <vertexname>, <edgeweight>]
--To the form [(vertexindex, vertexindex, edgeweight)]
--For use in the Data.Graph class
edgestoledges :: [[String]] -> [(Int,String)] -> [(Int, Int, Int)]
edgestoledges edges vertices = map (\[x,y,z] -> (getvertexindex x vertices, getvertexindex y vertices, read $ z :: Int)) edges

--Finds the index of a given vertex in a graph
getvertexindex :: String -> [(Int, String)] -> Int
getvertexindex vertexname vertices = fromJust $ findIndex (\(x,y) -> y == vertexname) vertices

--Generates a Data.Graph structure based on lists of vertices and edges
genGraph :: [(Int, String)] -> [(Int, Int, Int)] -> Gr String Int
genGraph vertices edges = mkGraph vertices edges

--Finds the minimum distance out of all the unchecked distances
getminweightandindex :: [(Int, Int)] -> (Int, Int)
getminweightandindex uncheckeddistances = (sortBy (\(a,_) (b,_)-> compare a b) uncheckeddistances) !! 0

--The heart of the difficult haskell coding, takes the distance from
--source of the current node, the master list of all distances in the form 
--[(<currentshortestdistancefromsource>, <vertexindex>)] and a list of all edges
--connected to the current node [<edgeweight, neighborindex>]
updatedistance :: Int ->[(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
updatedistance weight distance [] = distance
updatedistance weight distance ((a,b):as) = 
	let{
	distance' = map
	(\(c,d) -> if (d == b && weight < maxBound && a < maxBound && a + weight < c) 
		then (a + weight, d) 
		else (c,d)) 
		distance;
	} in updatedistance weight distance' as
	 


--Takes a graph, the index of the source vertex, list of distances in the form
--[<shortestdistancefromsource>,<vertexindex>] that is updated with each
--recursive call, and a list of unchecked vertex indices that is decremented with
--every recursive call.
recursedijkstras :: Gr String Int -> Int -> [(Int,Int)] -> [Int] -> [Int]
recursedijkstras graph source distance [] = map fst distance
recursedijkstras graph source distance unchecked = let{
			uncheckeddistances = [distance !! i | i <- unchecked];	
			node =  getminweightandindex uncheckeddistances;
			unchecked' = delete (snd node) unchecked;
			adjacent = lneighbors' (context  graph (snd node));
			distance' = (updatedistance (fst node) distance adjacent);
			} in recursedijkstras graph source distance' unchecked'		



--Initializes the distance from source to the maxBound of integers for non-source 
--vertices and 0 for the source itself. Initializes an unchecked list of all the 
--vertices in the graph then calls recursedijkstras which will continuosly update
--the distance list until the unchecked list is empty
dijkstras :: Int -> Gr String Int -> [Int]
dijkstras source graph = let{
		distance = [(if i == source then 0 else maxBound :: Int, i) | i <- [0 .. (noNodes graph)-1]];
		unchecked = [i | i <- [0 .. (noNodes graph) -1]];
	}in recursedijkstras graph source distance unchecked



--Parses the input file for lists of edges and vertices corresponding to the 
--formulation of the data.graph class. Then calls dijkstras on every node
--in the graph finding their shortest paths to every other node in the graph and
--storing them in result
main = do
	putStrLn "Enter Name of Graph File to Parse"
	filename <- getLine
	file <- readFile filename
	let numberofnodes = read $ (words file) !! 1 :: Int
	let vertices = [(i - 2, (words file) !! i) | i <- [2 .. 1 + numberofnodes]]
	let edges = chunksOf 3 ((splitWhen (== "Edges") (words file)) !! 1)
	let ledges = edgestoledges edges vertices
	let graph = genGraph vertices ledges
	let nvertices = noNodes graph
	let result = [(vertices !! i , dijkstras i graph) | i <- [0 .. nvertices-1]]
	mapM_ print result


