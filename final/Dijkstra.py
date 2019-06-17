
#gives the minimum distance in the list that has not been vsited and is accessible
def findMin (distances, visited) :


	m = -1;
	index = -1;
	count = 0;
	for i in distances:
		if m == -1 and i> 0 and visited.get(count) == 0 :
			m = i
			index = count
			visited[index] = 1
		elif i < m and i>0 and visited.get(count) == 0:
			m = i
			if index != -1:
				visited[index] = 0
			index = count
			visited[index] = 1
		count = count + 1



	return index, m


#updates the distance list based on the weight returned, so if A-B-C is shorter than A-C it fixes that
def update (distances, visited, index, edges, weight) :
	
	count = 0
	for i in edges[index] :
		if i != 0 :
			if i + weight < distances[count] or distances[count] == 0 :
				if visited[count] !=1:
					distances[count] = i + weight


		count = count + 1


	return distances


#the driver for the algorithm, creates the visited and distances and goes through to each node
def Dijkstra(node_num, node, n, nodes, edges) :

	distances = []
	queue = []
	visited = {}

	k=0
	for i in nodes:
		if i==node :
			visited[k] = 1
			k= k+ 1
			continue
		visited[k] = 0
		k= k+1

	#print node, visited

	for i in range(n) :
		distances.append(0)

	count = 0
	for i in edges[node_num] :
		if count != node_num:
			distances[count] = i
		count = count + 1

	#print(distances)
	#print(visited)
	
	k = 0
	while True :
		
		index, weight = findMin(distances, visited)
		if index == -1:
			break
		
		distances = update(distances, visited, index, edges, weight)
		

	

	return distances






#parses the file to store the nodes and the edges
def readFile(data) :

	n = 0
	switch = 0
	nodes = []
	edges = []
	count = 0
	for s in data:
		s = s.strip()
		s = s.split()
		if s[0] == "Nodes" :
			n = int(s[1])
			edges = [[0] * n for _ in range(n)]
			continue
		if s[0] == "Edges" :
			switch = 1
			continue
		if switch == 0:
			nodes.append(s[0])
			#SSSprint(s[0])
			count = count + 1
			continue
		if switch == 1:
			check = 0
			count = 0
			for k in nodes:
				if k == s[0]:
					i = count
					check = check + 1
				elif k == s[1]:
					j= count
					check = check + 1
				if check == 2:
					break
				count = count +1

			if check != 2:
				print("Error. Invalid edge. Exiting")
				exit(-1)


			edges[i][j] = int(s[2])
			edges[j][i] = int(s[2])

	return nodes, edges, n





#Reads in file, calls driver functions for each node, and prints out the result
def main() :

	filename = "graph.txt"

	try:
		fp = open(filename, "r")
	except :
		print("error opening graph data")
		exit(-1)

	data = fp.readlines()

	nodes, edges, n = readFile(data)


	#print(nodes)

	#for i in edges:
		#print(i)


	#algorithm

	paths = []
	for i in range(n):
		paths.append([])

	count = 0
	for i in nodes:
		paths[count] = Dijkstra(count, i, n, nodes, edges)	
		count = count + 1

	print"  ",
	for i in nodes:
		print i,
		print"",
	print ""
	k = 0
	for i in paths:
		print(nodes[k]),
		k= k+1
		print(i)




if __name__ == "__main__" :
	main()