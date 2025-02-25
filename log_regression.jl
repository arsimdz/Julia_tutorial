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
h(x) = 1 ./(1 .+exp.(-z(x)))

m = length(X)


function cost(x,y)
    (-1/m)*sum(
        x.*log.(y) + (1 .-x).*log.(1 .-y)
    )
end



function pd_theta_0(y_hat,y)
    sum(y_hat-y)
end

function pd_theta_1(y_hat,y)
    sum((y_hat-y).*X)
end

alpha = 0.01

loss = []
for i in 1:5000
    y_hat = h(X)
    push!(loss,cost(Y,y_hat))
    global theta_0 -= alpha*pd_theta_0(y_hat,Y)
    global theta_1 -= alpha*pd_theta_1(y_hat,Y)
end

p_scatter = scatter(X,Y,
  xlabel = "Size of grains of sand (mm)",
  ylabel = "Probability of observation",
  title = "Wolf spider presence classifier",
  legend = false,
  color = :red,
  markersize = 5
)

plot!(X,h(X),color= :blue,legend=false)

plot_loss = plot(1:5000,loss,
   title = "Loss",
   xlabel = "Number of iterations",
   ylabel = "Loss"
)
plot(p_scatter,plot_loss,layout=(2,1))
