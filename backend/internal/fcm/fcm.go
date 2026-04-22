package fcm

import (
	"context"
	"fmt"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
)

var client *messaging.Client

func Init() error {
	ctx := context.Background()
	app, err := firebase.NewApp(ctx, nil)
	if err != nil {
		return fmt.Errorf("error initializing Firebase app: %w", err)
	}

	var cErr error
	client, cErr = app.Messaging(ctx)
	if cErr != nil {
		return fmt.Errorf("error initializing FCM client: %w", cErr)
	}

	fmt.Println("Firebase FCM initialized")
	return nil
}

func intPtr(i int) *int {
	return &i
}

func SendToToken(ctx context.Context, token, title, body string, data map[string]string) error {
	if client == nil {
		return fmt.Errorf("FCM client not initialized")
	}

	message := &messaging.Message{
		Notification: &messaging.Notification{
			Title: title,
			Body:  body,
		},
		Data: data,
		Token: token,
		Android: &messaging.AndroidConfig{
			Priority: "high",
		},
		APNS: &messaging.APNSConfig{
			Payload: &messaging.APNSPayload{
				Aps: &messaging.Aps{
					Alert: &messaging.ApsAlert{
						Title: title,
						Body:  body,
					},
					Badge: intPtr(1),
					Sound: "default",
				},
			},
		},
	}

	_, err := client.Send(ctx, message)
	if err != nil {
		return fmt.Errorf("error sending FCM message: %w", err)
	}
	return nil
}

func SendMulticast(ctx context.Context, tokens []string, title, body string, data map[string]string) (*messaging.BatchResponse, error) {
	if client == nil {
		return nil, fmt.Errorf("FCM client not initialized")
	}

	message := &messaging.MulticastMessage{
		Notification: &messaging.Notification{
			Title: title,
			Body:  body,
		},
		Data:   data,
		Tokens: tokens,
		Android: &messaging.AndroidConfig{
			Priority: "high",
		},
	}

	br, err := client.SendEachForMulticast(ctx, message)
	if err != nil {
		return nil, fmt.Errorf("error sending multicast FCM: %w", err)
	}
	return br, nil
}
