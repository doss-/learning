from kafka import KafkaProducer


def main():
    producer = KafkaProducer(bootstrap_servers=['localhost:9092'])

    topic = raw_input("Enter topic:")

    while True:
        key = raw_input("Enter key:")
        value = raw_input("Enter value:")
        future = producer.send(topic, key=key, value=value)


if __name__ == "__main__":
    main()
