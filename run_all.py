import subprocess
from concurrent.futures import ThreadPoolExecutor

# Your configurations
configurations = [
    ['4kB', '32kB', '4', 'RandomRP', '2048kB', '8', 'LRURP'],
    ['4kB', '32kB', '2', 'LRURP', '2048kB', '32', 'LRURP'],
    ['8kB', '8kB', '4', 'LRURP', '1024kB', '8', 'RandomRP'],
    ['8kB', '32kB', '4', 'RandomRP', '2048kB', '8', 'LRURP'],
    ['8kB', '8kB', '1', 'LRURP', '512kB', '8', 'LRURP'],
    ['16kB', '16kB', '4', 'LRURP', '1024kB', '8', 'LRURP'],
    ['8kB', '8kB', '4', 'RandomRP', '1024kB', '8', 'LRURP'],
    ['8kB', '8kB', '2', 'LRURP', '512kB', '8', 'LRURP'],
    ['4kB', '32kB', '2', 'RandomRP', '2048kB', '8', 'LRURP'],
    ['8kB', '16kB', '1', 'LRURP', '1024kB', '8', 'LRURP'],
    ['8kB', '8kB', '4', 'LRURP', '512kB', '8', 'RandomRP'],
    ['8kB', '8kB', '2', 'RandomRP', '512kB', '8', 'LRURP'],
    ['4kB', '16kB', '1', 'LRURP', '1024kB', '8', 'RandomRP']
]

# Function to run the script with parameters
def run_script(params):
    command = ['bash', 'Hetero_run_wu.sh', '32'] + params + ["exclusive"]
    print(f"Launching: {' '.join(command)}")
    subprocess.run(command)

# Use ThreadPoolExecutor to run in parallel
if __name__ == "__main__":
    max_workers = 30  # Adjust based on your CPU/GPU limits
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        executor.map(run_script, configurations)
