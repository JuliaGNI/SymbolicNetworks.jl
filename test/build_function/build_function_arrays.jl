using SymbolicNeuralNetworks: build_nn_function, SymbolicNeuralNetwork
using AbstractNeuralNetworks: Chain, Dense, NeuralNetwork
using Test
import Random
Random.seed!(123)

function build_function_for_array_valued_equation(input_dim::Integer=2, output_dim::Integer=1)
    ch = Chain(Dense(input_dim, output_dim, tanh))
    nn = NeuralNetwork(ch)
    snn = SymbolicNeuralNetwork(nn)
    eqs = [(a = ch(snn.input, snn.params), b = ch(snn.input, snn.params).^2), (c = ch(snn.input, snn.params).^3, )]
    funcs = build_nn_function(eqs, snn.params, snn.input)
    input = Vector(1:input_dim)
    a = ch(input, nn.params)
    b = ch(input, nn.params).^2
    c = ch(input, nn.params).^3
    funcs_evaluated = funcs(input, nn.params)
    funcs_evaluated_as_vector = [funcs_evaluated[1].a, funcs_evaluated[1].b, funcs_evaluated[2].c]
    result_of_standard_computation = [a, b, c]

    @test funcs_evaluated_as_vector ≈ result_of_standard_computation
end

for input_dim ∈ (2, 3)
    for output_dim ∈ (1, 2)
        build_function_for_array_valued_equation(input_dim, output_dim)
    end
end