import Debug.Trace

trace' a = trace ("Tracing: " ++ show a) a

-- Maximum input size to test
maxInputSize = 100000

-- The result of interest contains an input size, a batch size, and its
-- corresponding number of parallel values
data Result = Result Int Int Int

-- Result can be compared by comparing the number of parallel values.
-- A result with a lower number of parallel values is superior because it
-- involves less wall-clock time.
instance Eq Result where
    (Result _ _ a) == (Result _ _ b) = a == b
instance Ord Result where
    compare (Result _ _ a) (Result _ _ b) = compare a b

-- Show result like a tuple
instance Show Result where
    show (Result inputSize batchSize parallelValues) =
      show (inputSize, batchSize, parallelValues)

main :: IO ()
main = do
    -- Create a list up to the maximum input size
    let inputSizes = take maxInputSize $ iterate (+ 1) 2
    -- Compute optimal batch size for each input size
    let results = map computeResults inputSizes
    -- Show the optimal result
    mapM_ (putStrLn . show . fst) results
    -- Uncomment this to see the optimal as well as all the results
    --mapM_ (putStrLn . show) results

-- Given an input size, produce all the results as well as the optimal
-- result, which is determined by the lowest number of parallel values
computeResults :: Int -> (Result, [Result])
computeResults inputSize = (optimal, results)
  where
    results = computeResult inputSize
    optimal = minimum results

-- Given an input size, produce all possible results
computeResult :: Int -> [Result]
computeResult inputSize = map computePValues batchSizes
  where
    -- Possible batch sizes range from 2 up to n
    batchSizes = takeWhile (<= inputSize) $ iterate (+ 1) 2
    -- Compute a result given a batch size and an input size
    computePValues batchSize =
      Result inputSize batchSize (sum $ computeParallelValues batchSize inputSize)

-- Given a batch size, which is fixed, and a recursively applied input
-- size, reduce until there is only one value and return a list of values
-- that need to be compared at each step.
computeParallelValues :: Int -> Int -> [Int]
computeParallelValues batchSize inputSize =
  let
    -- Only take the integer quotient as the number of batches in a step
    batchCount = inputSize `div` batchSize
    -- Sometimes it doesn't divide evenly
    remainderBatchSize = inputSize `mod` batchSize
    -- The output size is always the number of batches plus 1, if there is
    -- a remainder.
    outputSize = batchCount + if remainderBatchSize > 0 then 1 else 0

  in
    case batchCount of
      -- We're reaching the end! There's always one comparison at the end,
      -- unless there's only one value.
      0 -> if remainderBatchSize > 1 then [remainderBatchSize] else []
      -- We calculate the number of values that we need to go through
      -- (which is always just the batch size) in parallel in this step and
      -- continue reduction
      _ -> (batchSize:computeParallelValues batchSize outputSize)
