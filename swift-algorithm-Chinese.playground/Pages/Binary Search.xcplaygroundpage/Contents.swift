//: [Previous](@previous)
//: # Binary Search
//: An unsorted array of numbers
//: Goal: Quickly find an element in an array.
//:
//: Let's say you have an array of numbers and you want to determine whether a specific number is in that array, and if so, at which index.
//:
//: In most cases, Swift's `indexOf()` function is good enough for that:
let numbers_1 = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]
numbers_1.indexOf(43)  // returns 15
//: The built-in `indexOf()` function performs a [linear search](../Linear Search/). In code that looks something like this:
func linearSearch<T: Equatable>(a: [T], _ key: T) -> Int? {
	for i in 0 ..< a.count {
		if a[i] == key {
			return i
		}
	}
	return nil
}
//: And you'd use it like this:
linearSearch(numbers_1, 43)  // returns 15
//: So what's the problem? `linearSearch()` loops through the entire array from the beginning until it finds the element you're looking for. In the worst case, the value isn't in the array and all that work is done for nothing.
//:
//: On average, the linear search algorithm needs to look at half the values in the array. If your array is large enough, this starts to become very slow!
//:
//: ## Divide and conquer
//:
//: The classic way to speed this up is to use a *binary search*. The trick is to keep splitting the array in half until the value is found.
//:
//: For an array of size `n`, the performance is not **O(n)** as with linear search but only **O(log n)**. To put that in perspective, binary search on an array with 1,000,000 elements only takes about 20 steps to find what you're looking for, because `log_2(1,000,000) = 19.9`. And for an array with a billion elements it only takes 30 steps. (Then again, when was the last time you used an array with a billion items?)
//:
//: Sounds great, but there is one downside to using binary search: the array must be sorted. In practice, this usually isn't a problem.
//:
//: Here's how binary search works:
//:
//: - Split the array in half and determine whether the thing you're looking for, known as the *search key*, is in the left half or in the right half.
//: - How do you determine in which half the search key is? This is why you sorted the array first, so you can do a simple less-than or greater-than comparison.
//: - If the search key is in the left half, you repeat the process there: split the left half into two even smaller pieces and look in which piece the search key must lie. (Likewise for when it's the right half.)
//: - This repeats until the search key is found. If the array cannot be split up any further, you must regrettably conclude that the search key is not present in the array.
//:
//: Now you know why it's called a "binary" search: in every step it splits the array into two halves. This process of *divide-and-conquer* is what allows it to quickly narrow down where the search key must be.
//:
//: ## The code
//: Here is a recursive implementation of binary search in Swift:
let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]
//: Binary search requires that the array is sorted from low to high
let sorted = numbers.sort()
//: ### The recursive version of binary search.
func binarySearch<T: Comparable>(a: [T], key: T, range: Range<Int>) -> Int? {
	if range.startIndex >= range.endIndex {
		// If we get here, then the search key is not present in the array.
		return nil
	} else {
		// Calculate where to split the array.
		let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
		// Is the search key in the left half?
		if a[midIndex] > key {
			return binarySearch(a, key: key, range: range.startIndex ..< midIndex)
		// Is the search key in the right half?
		} else if a[midIndex] < key {
			return binarySearch(a, key: key, range: midIndex + 1 ..< range.endIndex)
		// If we get here, then we've found the search key!
		} else {
			return midIndex
		}
	}
}

binarySearch(sorted, key: 2, range: 0 ..< sorted.count)
binarySearch(sorted, key: 67, range: 0 ..< sorted.count)
binarySearch(sorted, key: 43, range: 0 ..< sorted.count)
binarySearch(sorted, key: 42, range: 0 ..< sorted.count)
//: To try this out, copy the code to a playground and do:
//:
//:		let numbers_2 = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
//:		binarySearch(numbers_2, key: 43, range: 0..< numbers_2.count)  // gives 13
//:
//: Note that the `numbers` array is sorted. The binary search algorithm does not work otherwise!
//:
//: I said that binary search works by splitting the array in half, but we don't actually create two new arrays. Instead, we keep track of these splits using a Swift `Range` object.
//:
//: Initially, this range covers the entire array, `0 ..< numbers.count`.  As we split the array, the range becomes smaller and smaller.
//:
//: > **Note:** One thing to be aware of is that `range.endIndex` always points one beyond the last element. In the example, the range is `0..<19` because there are 19 numbers in the array, and so `range.startIndex = 0` and `range.endIndex = 19`. But in our array the last element is at index 18, since we start counting from 0. Just keep this in mind when working with ranges: the `endIndex` is always one more than the index of the last element.
//:
//: ## Stepping through the example
//:
//: It might be useful to look at how the algorithm works in detail.
//:
//: The array from the above example consists of 19 numbers and looks like this when sorted:
//:
//: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
//:
//: We're trying to determine if the number `43` is in this array.
//:
//: To split the array in half, we need to know the index of the object in the middle. That's determined by this line:
//:
//:		let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
//: Initially, the range has `startIndex = 0` and `endIndex = 19`. Filling in these values, we find that `midIndex` is `0 + (19 - 0)/2 = 19/2 = 9`. It's actually `9.5` but because we're using integers, the answer is rounded down.
//:
//: In the next figure, the `*` shows the middle item. As you can see, the number of items on each side is the same, so we're split right down the middle.
//:
//: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
//: *
//:
//: Now binary search will determine which half to use. The relevant section from the code is:
//:
//: 	if a[midIndex] > key {
//: 		// use left half
//: 	} else if a[midIndex] < key {
//: 		// use right half
//: 	} else {
//: 		return midIndex
//: 	}
//: In this case, `a[midIndex] = 29`. That's less than the search key, so we can safely conclude that the search key will never be in the left half of the array, since that only contains numbers smaller than `29`. Hence, the search key must be in the right half somewhere (or not in the array at all).
//:
//: Now we can simply repeat the binary search, but on the array interval from `midIndex + 1` to `range.endIndex`:
//:
//: [x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43, 47, 53, 59, 61, 67]
//:
//: Since we no longer need to concern ourselves with the left half of the array, I've marked that with `x`'s. From now on we'll only look at the right half, which starts at array index 10.
//:
//: We calculate the index of the new middle element: `midIndex = 10 + (19 - 10)/2 = 14`, and split the array down the middle again.
//:
//: [ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
//: *
//:
//: As you can see, `a[14]` is indeed the middle element of the array's right half.
//:
//: Is the search key greater or smaller than `a[14]`? It's smaller because `43 < 47`. This time we're taking the left half and ignore the larger numbers on the right:
//:
//: [ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43 | x, x, x, x, x ]
//:
//: The new `midIndex` is here:
//:
//: [ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43 | x, x, x, x, x ]
//: *
//:
//: The search key is greater than `37`, so continue with the right side:
//:
//: [ x, x, x, x, x, x, x, x, x, x | x, x | 41, 43 | x, x, x, x, x ]
//: *
//:
//: Again, the search key is greater, so split once more and take the right side:
//:
//: [ x, x, x, x, x, x, x, x, x, x | x, x | x | 43 | x, x, x, x, x ]
//: *
//:
//: And now we're done. The search key equals the array element we're looking at, so we've finally found what we were looking for. Number `43` is at array index `13`. w00t!
//:
//: It may have seemed like a lot of work, but in reality it only took four steps to find the search key in the array, which sounds about right because `log_2(19) = 4.23`. With a linear search, it would have taken 14 steps.
//:
//: What would happen if we were to look for `42` instead of `43`? In that case, we can't split up the array any further.The `range.endIndex` becomes smaller than `range.startIndex` and that tells the algorithm the search key is not in the array and it returns `nil`.
//:
//: > **Note:** Many implementations of binary search calculate `midIndex = (start + end) / 2`. This contains a subtle bug that only appears with very large arrays, because `start + end` may overflow the maximum number an integer can hold. This situation is unlikely to happen on a 64-bit CPU, but it definitely can on 32-bit machines.
//:
//: ## Iterative vs recursive
//:
//: Binary search is recursive in nature because you apply the same logic over and over again to smaller and smaller subarrays. However, that does not mean you must implement `binarySearch()` as a recursive function. It's often more efficient to convert a recursive algorithm into an iterative version, using a simple loop instead of lots of recursive function calls.
//:
//: Here is an iterative implementation of binary search in Swift:
//:
//: ### The iterative version of binary search.
//: Notice how similar these functions are. The difference is that this one
//: uses a while loop, while the other calls itself recursively.
func binarySearch<T: Comparable>(a: [T], key: T) -> Int? {
	var range = 0..<a.count
	while range.startIndex < range.endIndex {
		let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
		if a[midIndex] == key {
			return midIndex
		} else if a[midIndex] < key {
			range.startIndex = midIndex + 1
		} else {
			range.endIndex = midIndex
		}
	}
	return nil
}

binarySearch(sorted, key: 2)
binarySearch(sorted, key: 67)
binarySearch(sorted, key: 43)
binarySearch(sorted, key: 42)
//: As you can see, the code is very similar to the recursive version. The main difference is in the use of the `while` loop.
//:
//: Use it like this:
//:		let numbers_3 = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
//:		binarySearch(numbers_3, key: 43)  // gives 13
//: ## The end
//:
//: Is it a problem that the array must be sorted first? It depends. Keep in mind that sorting takes time -- the combination of binary search plus sorting may be slower than doing a simple linear search. Binary search shines in situations where you sort just once and then do many searches.
//:
//: See also [Wikipedia](https://en.wikipedia.org/wiki/Binary_search_algorithm).
//:
//: *Written by Matthijs Hollemans*
//:
//: [Next](@next)
