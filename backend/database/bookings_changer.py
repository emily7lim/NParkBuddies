import pandas as pd
import random

bookings = pd.read_csv('bookings.csv')

datetime = bookings['datetime']

# Split the datetime into date and time
date = bookings['datetime'].str.split(' ', expand=True)[0]
time = bookings['datetime'].str.split(' ', expand=True)[1]

# Round the time to the nearest hour, format as HH:00:00
time = time.str.split(':', expand=True)[0] + ':00:00'

# Restrict to 8am to 7pm, if time is outside this range, randomly select a time between 8am and 7pm
time = time.apply(lambda x: x if '09:00:00' <= x <= '19:00:00' else f'{str(random.randint(8, 19)).zfill(2)}:00:00')

# Combine date and time back together
datetime = date + ' ' + time

# Save the new datetime back to the bookings dataframe
bookings['datetime'] = datetime

# Save the bookings dataframe to csv file
bookings.to_csv('bookings.csv', index=False)