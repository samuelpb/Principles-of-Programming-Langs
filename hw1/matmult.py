def printit(matrix, x1, y1):
    #function to print the matrix out, line by line
    for i in range(x1) :
        for j in range(y1) :
            print(matrix[i][j], end=' ')
        print()
    return


def multiply(matrix1, matrix2, x1, y2, shared):
    #function to multiply two matricies
    result = [[0 for j in range(y2)] for i in range(x1)]
    product = 0;

    #go across first and down second, add products, then move down the row in the first matrix
    #/over in the second matrix

    for i in range(x1) :
        for j in range(y2) :
            for k in range(shared) :
                product += matrix1[i][k] * matrix2[k][j];
            result[i][j] = product
            product = 0

    return result


def main():

    #read int he two matricies and their values
    try:
        s = input()
    except EOFError:
        print("invalid input")
        return
    s = s.split()
    x1 = int(s[0])
    y1 = int(s[1])
    if x1 <= 0 or y1 <= 0:
        print("invalid input")
        return

    matrix1 = [[0 for j in range(y1)] for i in range(x1)]

    for i in range (x1):
        try:
            s = input()
        except EOFError:
            print("invalid input")
            return
        s = s.split(' ')
        for j in range (y1) :
            matrix1[i][j] = float(s[j]);

    try:
        s = input()
    except EOFError:
        print("invalid input")
        return
    s = s.split()
    x2 = int(s[0])
    y2 = int(s[1])
    if x2 <= 0 or y2 <= 0:
        print("invalid input")
        return

    #if the matricies cannot be multiplies
    if y1 != x2:
        print('invalid input')
        return

    matrix2 = [[0 for j in range(y2)] for i in range(x2)]

    for i in range(x2):
        try:
            s = input()
        except EOFError:
            print("invalid input")
            return
        s = s.split(' ')
        for j in range(y2):
            matrix2[i][j] = float(s[j]);

    #call the multiply function and print out the result
    result = multiply(matrix1, matrix2, x1, y2, x2)
    printit(result, x1, y2)
    return


if __name__ == '__main__' :
    main()