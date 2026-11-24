import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { randomUUID } from "crypto";

const dynamo = new DynamoDBClient({ region: process.env.AWS_REGION || "us-east-1" });

export const handler = async (event) => {
  console.log("Event:", JSON.stringify(event, null, 2));

  try {
    const attrs  = event?.Details?.ContactData?.Attributes || {};
    const params = event?.Details?.Parameters || {};

    const customerEmail = attrs.CustomerEmail || params.CustomerEmail || "NOT_PROVIDED";
    const customerName  = attrs.CustomerName  || params.CustomerName  || "NOT_PROVIDED";
    const pageSource    = attrs.page_source   || params.page_source   || "unknown";
    const leadType      = attrs.lead_type     || params.lead_type     || "general";
    const contactId     = event?.Details?.ContactData?.ContactId      || randomUUID();
    const channel       = event?.Details?.ContactData?.Channel        || "CHAT";

    const leadId           = `LEAD-${Date.now()}-${contactId.slice(0,8).toUpperCase()}`;
    const captureTimestamp = new Date().toISOString();

    await dynamo.send(new PutItemCommand({
      TableName: process.env.DYNAMODB_TABLE || "FixYaChips_Leads",
      Item: {
        Email:            { S: customerEmail },
        CaptureTimestamp: { S: captureTimestamp },
        LeadId:           { S: leadId },
        ContactId:        { S: contactId },
        CustomerName:     { S: customerName },
        PageSource:       { S: pageSource },
        LeadType:         { S: leadType },
        Channel:          { S: channel },
        Environment:      { S: process.env.ENVIRONMENT || "production" },
        TTL:              { N: String(Math.floor(Date.now()/1000) + 7776000) }
      }
    }));

    console.log(`Lead saved: ${leadId} | email=${customerEmail} | page=${pageSource}`);

    return {
      LeadId:       leadId,
      LeadCaptured: "true",
      PageSource:   pageSource,
      LeadType:     leadType,
      Status:       "SUCCESS",
      ErrorMessage: ""
    };

  } catch (err) {
    console.error("Error:", err);
    return {
      LeadCaptured: "false",
      Status:       "ERROR",
      ErrorMessage: err.message
    };
  }
};
