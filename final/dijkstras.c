#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#define MAX_LENGTH 255

//Finds the index in the graph corresponding to the vertex name
int getindex(char * vertexname, int nnodes, char ** nodes)
{
	int i;
	for( i = 0; i < nnodes; i++)
	{	
		if(!strcmp(nodes[i], vertexname))
		{
			return i;
		}
	}

	printf("ERROR Get index failed\n");
	return -1;
}


//Sets the 2d array passed as an argument to contain all zeros
void zero2darray(int nnodes, int ** array)
{
	int m;
	int n;

	for(m = 0; m < nnodes; m++)
	{
		for(n = 0; n < nnodes; n++)
		{
			array[m][n] = 0;
		}
	}
	return;
}

//Helper function that prints out the result of dijkstras in the same format as the haskell program
void printresult(char ** nodes, int nnodes, int ** array)
{
	int m;
	int n;
	for( m = 0; m < nnodes; m++)
	{
		printf("((%d,\"%s\"),[",getindex(nodes[m],nnodes,nodes),nodes[m]);
		for( n = 0; n < nnodes; n++)
		{
			if(n < nnodes - 1)
			{
				printf("%d,", array[m][n]);
			}
			else
			{
				printf("%d",array[m][n]);
			}
		}
		printf("])\n");
	}
	return;
}

//Returns the index of the minimum distance not yet in shortestpathset
int indexofmindistance(int nnodes, int * distance, int * shortestpathset)
{

	int min = INT_MAX;	
	int index;
	int i;
	

	for(i = 0; i < nnodes; i++)
	{	
		if(!shortestpathset[i] && distance[i] <= min)
		{
			min = distance[i];
			index = i;
		}
	}

	return index;

}


//Takes the total number of nodes, the list of distances, a boolean list of 
//whether or not a given vertex has been checked, and a graph representation and 
//updates the list of minimum distances iteratively
int * iterativedijkstras(int nnodes, int * distance, int * shortestpathset, int ** graph)
{ 

	int iterations;
	int index;	
	int neighbor;

	for(iterations = 1; iterations <= nnodes - 1; iterations++)
	{
		index = indexofmindistance(nnodes, distance, shortestpathset);

		shortestpathset[index] = 1;

		for(neighbor = 0; neighbor < nnodes; neighbor++)
		{	
			if(graph[index][neighbor] != 0 
				&& !shortestpathset[neighbor] 
				&& distance[index] != INT_MAX 
				&& distance[index] + graph[index][neighbor]<distance[neighbor])
			{
				distance[neighbor] = distance[index] + graph[index][neighbor];
			}
		}	

	}

	return distance;
}



//Creates an array of integers representing the current distances
//Creates a shortestpathset that determines whether the minimum distance
//from the source to the given vertex has already been finalized
//Then passes these arguments to the function that updates the distances
//iteratively until it contains all the shortest paths for the given source
int * dijkstras(int nnodes, int ** graph, int source)
{
	int * distance = (int *) malloc(nnodes * sizeof(int));
	int * shortestpathset = (int *) malloc(nnodes * sizeof(int));

	int i;

	for(i = 0; i < nnodes; i++)
	{
		distance[i] = INT_MAX;
		shortestpathset[i] = 0;
	}
	
	distance[source] = 0;

	return iterativedijkstras(nnodes, distance, shortestpathset, graph);

}


//Calls dijkstras from all of the vertices in the graph storing in the 2d
//array shortestpaths
int populateallshortestpaths(int nnodes, int ** graph, int ** shortestpaths)
{
	int i;
	for(i = 0; i < nnodes; i++)
	{
		shortestpaths[i] = dijkstras(nnodes, graph, i);	
	}

}



//Parses the input file passed in as a command line argument
//
int main(int argv, char ** argc)
{
	if(argv != 2)
	{
		printf("ERROR Must pass in a file name\n");
		return 0;
	}
	
	FILE * graphfile = fopen(argc[1], "r");
	if(!graphfile)
	{
		printf("ERROR Unable to open file: %s\n",argc[1]);
		return 0;
	}
	int nnodes;
	if(fscanf(graphfile,"%*s %d",&nnodes) != 1)
	{
		printf("ERROR Graph file incorrectly formulated\n");
		return 0;
	}

	int i;
	char * nodes[nnodes];
	for(i = 0; i<nnodes; i++)
	{
		nodes[i] = (char *) malloc( MAX_LENGTH);
		if(fscanf(graphfile," %s ", nodes[i]) != 1)
		{
			printf("ERROR Graph file incorrectly formulated\n");
			return 0;
		}
	}
	


	char edges[6];	

	if(fscanf(graphfile, " %s ",&edges) != 1)
	{
		printf("ERROR Graph file incorrectly formulated\n");
		return 0;
	}
	
	char * node1 = (char *) malloc( MAX_LENGTH);
	char * node2 = (char *) malloc( MAX_LENGTH);
	int edgeweight;
	int m;
	int n;


	int ** graph = (int **) malloc(nnodes * sizeof(int*));
	for(i = 0; i < nnodes; i++)
	{
		graph[i] = (int *) malloc(nnodes * sizeof(int));
	}	


	int ** shortestpaths = (int **) malloc(nnodes * sizeof(int*));

	zero2darray(nnodes, graph);

	int index1;
	int index2;
	while(fscanf(graphfile, " %s %s %d ", node1, node2, &edgeweight) == 3)
	{
		index1 = getindex(node1, nnodes, nodes);
		index2 = getindex(node2, nnodes, nodes);
		graph[index1][index2] = edgeweight;
		graph[index2][index1] = edgeweight;
	}
	
	populateallshortestpaths(nnodes, graph, shortestpaths);

	
	printresult(nodes, nnodes, shortestpaths);

	fclose(graphfile);

	return 0;
}


