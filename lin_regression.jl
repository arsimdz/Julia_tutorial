

using CSV,Plots,TypedTables

data = CSV.File("housingdata.csv")
x = data.size
y = round.(Int, data.price/1000)
m = length(x)
function cost(x,y)
     (1/(2*m))*sum((x-y).^2)
end



function gradient_descent(x,epochs,theta,b,alpha,y)
    
    loss = []
    for i in 1:epochs
        y_hat = theta*x .+b
        push!(loss,cost(y_hat,y))
        theta -= alpha[2]*sum((y_hat-y).*x)*(1/m)
        b -= alpha[1]*sum(y_hat-y)*(1/m)
    end
    return theta,b,loss
end

theta = 0
b = 0
alpha = [0.09,0.00000008]
epochs = 50

theta,b,loss = gradient_descent(x,epochs,theta,b,alpha,y)
println(theta)
println(b)
y_hat = theta*x.+b
gr(size = (600, 600))

p_scatter = scatter(x, y,
    xlims = (0, 5000),
    ylims = (0, 800),
    xlabel = "Size (sqft)",
    ylabel = "Price (in thousands of dollars)",
    title = "Housing Prices in Portland (epochs = $epochs)",
    legend = false,
    color = :red
)

plot!(x, y_hat, color = :blue)


gr(size = (600, 600))

p_line = plot(1:epochs, loss,
    xlabel = "Epochs",
    ylabel = "Cost",
    title = "Learning Curve",
    legend = false,
    color = :blue,
    linewidth = 2
)
plot(p_scatter,p_line,legend=false,layout=(2,1))