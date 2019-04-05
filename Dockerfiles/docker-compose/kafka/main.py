from kafka import KafkaProducer


def main():
    producer = KafkaProducer(bootstrap_servers=['localhost:9092'])

    topic = input("Enter topic:")

    while True:
        key = input("Enter key:")
        value = input("Enter value:")
        future = producer.send(topic, key=key.encode('utf-8'), value=value.encode('utf-8'))


if __name__ == "__main__":
    main()
