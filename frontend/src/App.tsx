import { Banner, Button, Space, Typography } from "@douyinfe/semi-ui";

export function App() {
  return (
    <div style={{ margin: "32px auto", maxWidth: 920, padding: "0 16px" }}>
      <Banner
        type="info"
        title="React + Semi Design Starter"
        description="Use this as your feature entry page and split by business modules."
      />
      <Space vertical align="start" style={{ marginTop: 24 }}>
        <Typography.Title heading={3}>AI Coding Frontend Baseline</Typography.Title>
        <Typography.Text>
          Recommended: organize by route/domain under <code>frontend/src</code>.
        </Typography.Text>
        <Button theme="solid" type="primary">
          Primary Action
        </Button>
      </Space>
    </div>
  );
}

