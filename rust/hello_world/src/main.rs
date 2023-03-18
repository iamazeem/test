fn main() {
    println!("Hello, world!");
}

pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_add_1() {
        assert_eq!(1 + 2, 3);
    }

    #[test]
    fn test_add_2() {
        assert_eq!(1 - 2, -1);
    }
}
