function sum(vec) {
    let acc = vec[0]
    for (let i = 1; i < vec.length; i++) {
        acc = acc + vec[i]
    }
    return acc
}
