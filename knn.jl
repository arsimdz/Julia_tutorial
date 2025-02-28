using NearestNeighbors, Plots
using Random
using RDatasets,StatsBase
using Statistics


iris = dataset("datasets","iris")
X = Matrix(iris[:,1:4])
y = Vector{String}(iris.Species)

function perclass_splits(y, percent)
    uniq_class = unique(y)
    keep_index = []
    for class in uniq_class
        class_index = findall(y .== class)
        row_index = randsubseq(class_index, percent)
        push!(keep_index, row_index...)
    end
    return keep_index
end

Random.seed!(1)
index_train = perclass_splits(y,0.67)
index_test = setdiff(1:length(y),index_train)

X_train = X[index_train,:]
X_test = X[index_test,:]
y_train = y[index_train]
y_test = y[index_test]

X_train_t = permutedims(X_train)
X_test_t = permutedims(X_test)
y_train_t = permutedims(y_train)
y_test_t = permutedims(y_test)

kdtree = KDTree(X_train_t)

k = 5
index_knn, distance = knn(kdtree,X_test_t,k,true)

output = [index_test,index_knn,distance]

index_knn_matrix = hcat(index_knn...)
index_knn_matrix_t = permutedims(index_knn_matrix)

knn_classes = y_train[index_knn_matrix_t]

y_hat = [
    argmax(countmap(knn_classes[i,:]))
    for i in 1:length(y_test)
]

accuracy = mean(y_hat .== y_test)