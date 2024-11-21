import os
import tensorflow as tf

if __name__ == "__main__":
    devices = tf.config.list_physical_devices('GPU')
    print(f"process: {os.getpid()}, devices: {devices}")
