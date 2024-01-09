using LinearAlgebra

struct sphere
    center
    radius
end

function Base.iterate(s::sphere, state=1)
    if state == 1
        return (s.center, state + 1)
    elseif state == 2
        return (s.radius, nothing)
    end
end

function abs_cos(u, v)
    dot(u, v) / (norm(u) * norm(v))
end

function abs_cos(a, b, c)
    abs_cos(b - a, c - a)
end

function intersection_3_spheres(A::sphere, B::sphere, C::sphere)
    ABC = [
        [abs_cos(A.center, B.center, C.center), [A, B, C]],
        [abs_cos(B.center, C.center, A.center), [B, C, A]],
        [abs_cos(C.center, A.center, B.center), [C, A, B]],
    ]
    U, V, W = argmin(x -> x[1], ABC)[2]

    u, du = U
    v, dv = V
    w, dw = W

    n = normalize(cross(v - u, w - u))

    # TODO verificar a ordem aqui
    A = [(v - u) (w - u) n]'
    b = 0.5 * [
        dot(v, v) - dv^2 - dot(u, u) + du^2,
        dot(w, w) - dw^2 - dot(u, u) + du^2,
        2 * dot(u, n)
    ]

    p = A \ b

    dpu = norm(p - u)

    if du^2 - dpu^2 < 0
        error("No intersection")
    end

    dp = sqrt(du^2 - dpu^2)
    p + dp * n, p - dp * n
end
