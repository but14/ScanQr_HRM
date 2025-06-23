// material-ui
import Link from '@mui/material/Link';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';

export default function Footer() {
  return (
    <Stack direction="row" sx={{ alignItems: 'center', justifyContent: 'space-between', p: '24px 16px 0px', mt: 'auto' }}>
      <Typography variant="caption">
        &copy; Thiết kế và phát triển bởi Team Application
        
      </Typography>
      <Stack direction="row" sx={{ gap: 1.5, alignItems: 'center', justifyContent: 'space-between' }}>
      <Typography variant="caption">
        Cung cấp bởi Khối CNTT & Chuyển đổi số
        
        </Typography>
      </Stack>
    </Stack>
  );
}
