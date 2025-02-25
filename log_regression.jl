using CSV

data = CSV.File("wolfspider.csv")
X = data.feature
y_temp = data.class
Y = []

for i in y_temp
    if i == "present"
       y = 1.0
    else
        y=0.0
    end
    push!(Y,y)
end

theta_0 = 0.0
theta_1 = 1.0
z(x) = theta_0 .+ theta_1*x
h(x) = 1./(1.+exp.(-z(x)))

m = length(X)
y_hat = h(X)

function cost()
    (-1/m)*sum(
        Y.*log.(y_hat) + (1.-Y).*log.(1.-y_hat)
    )
end

J = cost()

function pd_theta_0()
    sum(y_hat-Y)
end

function pd_theta_1()
    sum((y_hat-Y)*.X)
end

alpha = 0.01