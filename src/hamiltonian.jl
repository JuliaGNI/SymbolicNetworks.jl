"""
    HamiltonianSymbolicNeuralNetwork

symbolic_hamitonian is a functions that creates a symbolic hamiltonian from any hamiltonian.
The output of the function is 
- the symbolics parameters used to build the hamiltonian (i.e t, q, p),
- the symbolic expression of the hamiltonian,
- the function generated from the symbolic hamiltonian. 
"""
function HamiltonianSymbolicNeuralNetwork(arch::Architecture, model::Model)

    input_dim = input_dimension(model)
    n = input_dim ÷ 2
    @assert iseven(input_dim) "Input dimension has to be an even number."
    @assert output_dimension(model) == 1 "Output dimension of network has to be scalar."

    @variables nn ∇nn
    x = Symbolics.variables(:x, 1:input_dim)

    𝕀 = I(n)
    𝕆 = zero(𝕀)
    𝕁 = hcat(vcat(𝕆, -𝕀), vcat(𝕀, 𝕆))
    eqs = (x = x, nn = nn, ∇nn = ∇nn, hvf = 𝕁 * ∇nn)

    SymbolicNeuralNetwork(arch, model; eqs = eqs)
end

input_dimension(::AbstractExplicitLayer{M}) where M = M
input_dimension(c::Chain) = input_dimension(c.layers[1])

output_dimension(::AbstractExplicitLayer{M, N}) where {M, N} = N
output_dimension(c::Chain) = output_dimension(c.layers[end])

HamiltonianSymbolicNeuralNetwork(model::Model) = HamiltonianSymbolicNeuralNetwork(UnknownArchitecture(), model)